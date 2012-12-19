
module.exports = express = require 'express'
http = require 'http'
https = require 'https'
io = require 'socket.io'

express.application.http = ->
    @server = http.createServer this
    return this

express.application.https = (options) ->
    @server = https.createServer options, this
    return this

express.application.io = ->
    @io = io.listen @server
    return this

listen = express.application.listen
express.application.listen = ->
    args = Array.prototype.slice.call arguments, 0
    if @server?
        @server.listen.apply @server, args
    else
        listen.apply this, args
        

