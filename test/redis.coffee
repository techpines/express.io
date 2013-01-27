
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
            , 1200
    , 2000

describe 'the multi-process redis example', ->
    it 'should work', (next) ->
        startExample '../examples/scaling-with-redis/app', next, (done) ->
            client = io.connect 'http://localhost:7076',
                'force new connection': true
            client.on 'connect', ->
                client.disconnect()
                done()
