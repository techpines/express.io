
should = require('chai').should()
io = require 'socket.io-client'

describe 'the express.io app', ->
    client = undefined
    before (done) ->
        app = require('../lib/index')()
        app.http().io()

        app.io.route 'test-respond', (request) ->
            console.log 'respond dummy'
            request.io.respond 'respond works'

        app.io.route 'test-emit', (request) ->
            console.log 'emit works good'
            request.io.emit 'test-emit', 'emit works'

        app.listen 7076, ->
            client = io.connect 'http://localhost:7076'
            done()


    it 'should emit', (done) ->
        client.on 'test-emit', (message) ->
            message.should.equal 'emit works'
            client.disconnect()
            done()
        client.emit 'test-emit'

    it 'should respond', (done) ->
        console.log 'should respond'
        
        client.emit 'test-respond', {}, (message) ->
            message.should.equal 'respond works'
            client.disconnect()
            done()

