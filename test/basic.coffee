
io = require 'socket.io-client'

describe 'a basic express.io app', ->
    app = null
    client = null
    otherClient = null
    beforeEach (done) ->
        app = require('../lib/index')()
        app.http().io()

        app.io.route 'test-respond', (request) ->
            request.io.respond 'respond works'

        app.io.route 'test-emit-no-data-with-callback', (request) ->
            request.io.respond junk: 'test'

        app.io.route 'test-emit', (request) ->
            request.io.emit 'test-emit', 'emit works'
    
        app.io.route 'test-broadcast', (request) ->
            request.io.broadcast 'test-broadcast', 'broadcast works'

        app.io.route 'test-broadcast-app', (request) ->
            app.io.broadcast 'test-broadcast-app', 'broadcast app works'

        app.io.route 'test-advanced-routing',
            first: (request) ->
                request.io.respond 'first'
            second: (request) ->
                request.io.respond 'second'

        app.io.route 'join', (request) ->
            request.io.join(request.data.room)
            request.io.respond ''

        app.io.route 'leave', (request) ->
            request.io.leave(request.data.room)
            request.io.respond ''
        
        app.io.route 'test-room', (request) ->
            app.io.room('test').broadcast 'test-room', 'rooms work'

        app.io.route 'test-room-leave', (request) ->
            app.io.room('test-leave').broadcast 'test-room-leave'
            request.io.respond ''

        app.listen 7076, ->
            client = io.connect 'http://localhost:7076',
                'force new connection': true
            otherClient = io.connect 'http://localhost:7076',
                'force new connection': true
            done()

    it 'should emit', (done) ->
        client.on 'test-emit', (message) ->
            message.should.equal 'emit works'
            done()
        client.emit 'test-emit'

    it 'should respond', (done) ->
        client.emit 'test-respond', (message) ->
            message.should.equal 'respond works'
            client.emit 'test-respond', {}, (message) ->
                message.should.equal 'respond works'
                done()
        


    it 'should broadcast', (done) ->
        otherClient.on 'test-broadcast', (message) ->
            message.should.equal 'broadcast works'
            done()
        client.on 'test-broadcast', (message) ->
            throw new Error 'This client should not receive.'
        client.emit 'test-broadcast'

    it 'should broadcast from app', (done) ->
        total = 0
        otherClient.on 'test-broadcast-app', (message) ->
            message.should.equal 'broadcast app works'
            total += 1
            done() if total is 2
        client.on 'test-broadcast-app', (message) ->
            message.should.equal 'broadcast app works'
            total += 1
            done() if total is 2
        client.emit 'test-broadcast-app'

    it 'should have rooms to join', (done) ->
        client.emit 'join', room: 'test', ->
            otherClient.emit 'test-room'
        client.on 'test-room', (message) ->
            message.should.equal 'rooms work'
            done()
        client
        otherClient.on 'test-room', (message) ->
            throw new Error 'should not receive this'
    it 'should have rooms to leave', (done) ->
        client.emit 'join', room: 'test-leave', ->
            client.emit 'leave', room: 'test-leave', ->
                otherClient.emit 'test-room-leave', {}, ->
                    setTimeout done, 10
        client.on 'test-room-leave', ->
            throw new Error 'should not receive this'
        otherClient.on 'test-room', ->
            throw new Error 'should not receive this'

    afterEach (done) ->
        client.disconnect()
        otherClient.disconnect()
        app.server.close ->
            done()


