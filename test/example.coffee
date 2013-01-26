
should = require('chai').should()
io = require 'socket.io-client'
spawn = require('child_process').spawn

startExample = (appName, done, next) ->
    app = spawn 'node', [appName]
    setTimeout ->
        next ->
            app.kill 'SIGKILL'
            setTimeout ->
                done()
            , 1500
    , 1500

describe 'the routing example', ->
    it 'should start and respond', (next) ->
        startExample '../examples/routing/app', next, (done) ->
            client = io.connect 'http://localhost:7076'
            client.on 'talk', (data) ->
                data.message.should.equal 'io event from an io route on the server'
                client.disconnect()
                done()
            client.emit 'ready'

