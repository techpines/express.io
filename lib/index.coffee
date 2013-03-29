connect = require 'express/node_modules/connect'
express = require 'express'
io = require 'socket.io'
http = require 'http'
https = require 'https'
async = require 'async'
middleware = require './middleware'
_ = require 'underscore'

RequestIO = require('./request').RequestIO
RoomIO = require('./room').RoomIO

express.io = io
express.io.routeForward = middleware.routeForward

session = express.session
delete express.session
sessionConfig = new Object
express.session = (options) ->
    options ?= new Object
    options.key ?= 'connect.sid'
    options.store ?= new session.MemoryStore
    options.cookie ?= new Object
    sessionConfig = options
    return session options
for key, value of session
    express.session[key] = value

express.application.http = ->
    @server = http.createServer this
    return this

express.application.https = (options) ->
    @server = https.createServer options, this
    return this

express.application.io = (options) ->
    options ?= new Object
    defaultOptions = log:false
    _.extend options, defaultOptions
    @io = io.listen @server, options
    @io.router = new Object
    @io.middleware = []
    @io.route = (route, next, options) ->
        if options?.trigger is true
            if route.indexOf ':' is -1
                @router[route] next
            else
                split = route.split ':'
                @router[split[0]][split[1]] next
        if _.isFunction next
            @router[route] = next
        else
            for key, value of next
                @router["#{route}:#{key}"] = value
    @io.configure => @io.set 'authorization', (data, next) =>
        unless sessionConfig.store?
            return async.forEachSeries @io.middleware, (callback, next) ->
                callback(data, next)
            , (error) ->
                return next error if error?
                next null, true
        cookieParser = express.cookieParser()
        cookieParser data, null, (error) ->
            return next error if error?
            rawCookie = data.cookies[sessionConfig.key]
            unless rawCookie?
                request = headers: cookie: data.query.cookie
                return cookieParser request, null, (error) ->
                    data.cookies = request.cookies
                    rawCookie = data.cookies[sessionConfig.key]
                    return next "No cookie present", false unless rawCookie?
                    sessionId = connect.utils.parseSignedCookie rawCookie, sessionConfig.secret
                    data.sessionID = sessionId
                    sessionConfig.store.get sessionId, (error, session) ->
                        return next error if error?
                        data.session = new connect.session.Session data, session
                        next null, true
                    
            sessionId = connect.utils.parseSignedCookie rawCookie, sessionConfig.secret
            data.sessionID = sessionId
            sessionConfig.store.get sessionId, (error, session) ->
                return next error if error?
                data.session = new connect.session.Session data, session
                next null, true

    @io.use = (callback) =>
        @io.middleware.push callback

    @io.sockets.on 'connection', (socket) =>
        initRoutes socket, @io

    @io.broadcast = =>
        args = Array.prototype.slice.call arguments, 0
        @io.sockets.emit.apply @io.sockets, args

    @io.room = (room) =>
        new RoomIO(room, @io.sockets)

    @stack.push
        route: ''
        handle: (request, response, next) =>
            request.io =
                route: (route) =>
                    ioRequest = new Object
                    for key, value of request
                        ioRequest[key] = value
                    ioRequest.io =
                        broadcast: @io.broadcast
                        respond: =>
                            args = Array.prototype.slice.call arguments, 0
                            response.json.apply response, args
                        route: (route) =>
                            @io.route route, ioRequest, trigger: true
                        data: request.body
                    @io.route route, ioRequest, trigger: true
                broadcast: @io.broadcast
            next()

    return this

listen = express.application.listen
express.application.listen = ->
    args = Array.prototype.slice.call arguments, 0
    if @server?
        @server.listen.apply @server, args
    else
        listen.apply this, args
        

initRoutes = (socket, io) ->
    setRoute = (key, callback) ->
        socket.on key, (data, respond) ->
            if typeof data is 'function'
                respond = data
                data = undefined
            request =
                data: data
                session: socket.handshake.session
                sessionID: socket.handshake.sessionID
                sessionStore: sessionConfig.store
                socket: socket
                headers: socket.handshake.headers
                cookies: socket.handshake.cookies
                handshake: socket.handshake
            session = socket.handshake.session
            request.session = new connect.session.Session request, session if session?
            socket.handshake.session = request.session
            request.io = new RequestIO(socket, request, io)
            request.io.respond = respond
            request.io.respond ?= ->
            callback request
    for key, value of io.router
        setRoute(key, value)


module.exports = express
