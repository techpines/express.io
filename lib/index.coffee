
module.exports = express = require 'express'
http = require 'http'
https = require 'https'
io = require 'socket.io'

express.application.http = ->
    @server = http.createServer this
    return this

express.application.https = (options) ->
    @server = http.createServer options, this
    return this

express.application.io = ->
    @io = io.listen @server
    return this

