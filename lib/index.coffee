
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

express.application.http = ->
    @server = http.createServer this
    return this

express.application.https = (options) ->
    @server = https.createServer options, this
    return this

express.application.io = ->
    @io = io.listen @server
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
    return this

initRoutes = (socket, router) ->
    for key, value of router
        socket.on key, (data, next) ->
            value
                body: data
                io: socket
                session: socket.handshake.session
                sessionID: socket.handshake.sessionID
                socket: socket
                headers: socket.handshake.headers
                cookies: socket.handshake.cookies
            , next
                
    

listen = express.application.listen
express.application.listen = ->
    args = Array.prototype.slice.call arguments, 0
    if @server?
        @server.listen.apply @server, args
    else
        listen.apply this, args
        
module.exports = express
