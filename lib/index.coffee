
connect = require 'connect'
express = require 'express'
io = require 'socket.io'
http = require 'http'
https = require 'https'

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

express.io = io

express.application.http = ->
    @server = http.createServer this
    return this

express.application.https = (options) ->
    @server = https.createServer options, this
    return this

express.application.io = (options) ->
    @io = io.listen @server
    @io = @io.of options.namespace if options?.namespace?
    @io.router = new Object
    @io.route = (route, next) ->
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
        initRoutes socket, @io.router
    @io.broadcast = =>
        args = Array.prototype.slice.call arguments, 0
        @io.sockets.emit.apply @io.sockets, args
    @io.room = (room) =>
        new SimpleRoom(room, @io.sockets)
    return this

initRoutes = (socket, router) ->
    setRoute = (key, value) ->
        socket.on key, (data, next) ->
            value
                data: data
                io: new SimpleSocket(socket)
                session: socket.handshake.session
                sessionID: socket.handshake.sessionID
                socket: socket
                headers: socket.handshake.headers
                cookies: socket.handshake.cookies
                handshake: socket.handshake
            , next
    for key, value of router
        setRoute(key, value)

listen = express.application.listen
express.application.listen = ->
    args = Array.prototype.slice.call arguments, 0
    if @server?
        @server.listen.apply @server, args
    else
        listen.apply this, args
        
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
    constructor: (socket) ->
        @socket = socket
    
    broadcast: (event, message) ->
        @socket.broadcast.emit(event, message)
    
    emit: (event, message) ->
        @socket.emit(event, message)

    room: (room) ->
        new SimpleRoom(room, @socket)

    join: (room) ->
        @socket.join(room)

    leave: (room) ->
        @socket.leave(room)

    on: (event, callback) ->
        @socket.on event, callback


module.exports = express
