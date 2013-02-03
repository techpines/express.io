
should = require('chai').should()
io = require 'socket.io-client'
easyrequest = require 'request'
spawn = require('child_process').spawn

app = null
other = null
client = null

startExample = (appName, done, next) ->
    app = spawn 'node', [appName]
    setTimeout ->
        next done
    , 750 # Allow the server time to start.

describe 'the routing example', ->
    it 'should work', (next) ->
        startExample '../examples/routing/app', next, (done) ->
            client = io.connect 'http://localhost:7076',
                'force new connection': true
            client.on 'talk', (data) ->
                data.message.should.equal 'io event from an io route on the server'
                client.disconnect()
                done()
            client.emit 'ready'

describe 'the route forwarding example', ->
    it 'should work', (next) ->
        startExample '../examples/route-forwarding/app', next, (done) ->
            easyrequest 'http://localhost:7076', (error, response, body) ->
                body = JSON.parse body
                body.hello.should.equal 'from io route'
                done()

describe 'the broadcast example', ->
    it 'should work', (next) ->
        startExample '../examples/broadcasting/app', next, (done) ->
            client = io.connect 'http://localhost:7076',
                'force new connection': true
            other = io.connect 'http://localhost:7076',
                'force new connection': true
            client.emit 'ready'
            other.on 'new visitor', ->
                done()
            client.on 'new visitor', ->
                throw new Error 'should not receive'

describe 'the session example', ->
    it 'should work', (next) ->
        startExample '../examples/sessions/app', next, (done) ->
            easyrequest 'http://localhost:7076', (error, response, body) ->
                cookie = response.headers['set-cookie']
                client = io.connect "http://localhost:7076?cookie=#{encodeURIComponent(cookie)}",
                    'force new connection': true
                client.emit 'ready', 'brad'
                client.on 'get-feelings', ->
                    client.emit 'send-feelings', 'good'
                client.on 'session', (session) ->
                    session.name.should.equal 'brad'
                    session.feelings.should.equal 'good'
                    should.exist session.loginDate
                    done()

describe 'the rooms example', ->
    it 'should work', (next) ->
        startExample '../examples/rooms/app', next, (done) ->
            client = io.connect 'http://localhost:7076',
                'force new connection': true
            other = io.connect 'http://localhost:7076',
                'force new connection': true
            client.on 'announce', (data) ->
                data.message.should.equal 'New client in the cool room. '
                done()
            client.emit 'ready', 'cool'
            setTimeout ->
                other.emit 'ready', 'cool'
            , 200

describe 'the acknowledgements example', ->
    it 'should work', (next) ->
        startExample '../examples/acknowledgements/app', next, (done) ->
            client = io.connect 'http://localhost:7076',
                'force new connection': true
            client.emit 'ready', {}, (data) ->
                data.success.should.equal 'here is your acknowledegment for the ready event'
                done()

describe 'the realtime canvas example', ->
    it 'should work', (next) ->
        startExample '../examples/realtime-canvas/app', next, (done) ->
            client = io.connect 'http://localhost:7076',
                'force new connection': true
            other = io.connect 'http://localhost:7076',
                'force new connection': true
            client.emit 'drawClick'
            other.on 'draw', ->
                done()
            client.on 'new visitor', ->
                throw new Error 'should not receive'

afterEach (done) ->
    client.disconnect() if client?
    other.disconnect() if other?
    if app?
        app.on 'exit', ->
            done()
    else
        return done()
    app.kill 'SIGKILL'
