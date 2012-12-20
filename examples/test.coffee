
express = require '../lib'
RedisStore = require('connect-redis') express
redis = require 'redis'

app = express()
app.http().io()
app.listen 3000

app.configure ->
    app.use express.cookieParser()
    app.use express.session
        secret: 'koho'
        store: new RedisStore(client: redis.createClient())
    app.set 'views', __dirname
   
app.get '/', (request, response) ->
    response.render 'test.jade'

app.get '/ping', (request, response) ->
    app.io.sockets.emit 'funky', count: request.session.count
    response.send 'ping'

app.io.route 'thanks', (request) ->
    session = request.session
    session.count ?= 1
    session.count += 1
    session.save()


