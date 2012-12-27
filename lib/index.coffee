
connect = require 'connect'
express = require 'express'
io = require 'socket.io'
http = require 'http'
https = require 'https'

express.io = io

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
    @io = io.listen @server
    @io.router = new Object
    @io.route = (route, next, options) ->
        return @router[route] next if options?.trigger is true
        @router[route] = next
    @io.configure => @io.set 'authorization', (data, next) =>
        return next null, true unless sessionConfig.store?
        cookieParser = express.cookieParser()
        cookieParser data, null, (error) ->
            return next error if error?
            rawCookie = data.cookies[sessionConfig.key]
            sessionId = connect.utils.parseSignedCookie rawCookie, sessionConfig.secret
            data.sessionID = sessionId
            sessionConfig.store.get sessionId, (error, session) ->
                return next error if error?
                data.session = new connect.session.Session data, session
                data.sessionStore = sessionConfig.store
                next null, true

    @io.sockets.on 'connection', (socket) =>
        initRoutes socket, @io

    @io.broadcast = =>
        args = Array.prototype.slice.call arguments, 0
        @io.sockets.emit.apply @io.sockets, args

    @io.room = (room) =>
        new SimpleRoom(room, @io.sockets)

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

setupRequest = (io) ->
    

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
            request =
                data: data
                session: socket.handshake.session
                sessionID: socket.handshake.sessionID
                socket: socket
                headers: socket.handshake.headers
                cookies: socket.handshake.cookies
                handshake: socket.handshake
            request.io = new SimpleSocket(socket, request, io)
            request.io.respond = respond
            request.io.respond ?= ->
            callback request
    for key, value of io.router
        setRoute(key, value)

class SimpleRoom
    constructor: (name, socket) ->
        @name = name
        @socket = socket
    broadcast: (event, message) ->
        if @socket.broadcast?
            @socket.broadcast.to(@name).emit event, message
        else
            @socket.in(@name).emit event, message

class SimpleSocket
    constructor: (socket, request, io) ->
        @socket = socket
        @request = request
        @manager = io
    
    broadcast: (event, message) ->
        @socket.broadcast.emit(event, message)
    
    emit: (event, message) ->
        @socket.emit(event, message)
    
    room: (room) ->
        new SimpleRoom(room, @socket)

    join: (room) ->
        @socket.join(room)

    route: (route) ->
        @manager.route route, @request, trigger: true

    leave: (room) ->
        @socket.leave(room)

    on: ->
        args = Array.prototype.slice.call arguments, 0
        @sockets.on.apply @socket, args

    disconnect: (callback) ->
        @socket.disconnect(callback)


module.exports = express
