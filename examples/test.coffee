
express = require '../lib'
app = express()

app.configure ->
    app.use express.cookieParser()
    app.use express.session
        secret: 'koho'
    app.set 'views', __dirname
   
app.get '/', (request, response) ->
    response.render 'test.jade'

app.get '/ping', (request, response) ->
    console.log 'ping'
    console.log request.session
    app.io.sockets.emit 'funky', count: request.session.count
    response.send 'ping'

app.http().io()

app.io.sockets.on 'connection', (socket) ->
    socket.on 'thanks', ->
        session = socket.handshake.session
        session.count ?= 1
        session.count += 1
        socket.handshake.session.save (error) ->

app.listen 3000
