express = require('express.io')
app = express().http().io()
redis = require('redis')
RedisStore = require('connect-redis')(express)

// Setup your sessions, just like normal.
app.use(express.cookieParser())
app.use(express.session({
    secret: 'monkey',
    store: new RedisStore({
        client: redis.createClient()  
    }) 
}))

app.io.set('store', new express.io.RedisStore({
    redisPub: redis.createClient(),
    redisSub: redis.createClient(),
    redisClient: redis.createClient(),
}))

// Session is automatically setup on initial request.
app.get('/', function(req, res) {
    req.session.loginDate = new Date().toString()
    res.sendfile(__dirname + '/client.html')
})

// Setup a route for the ready event, and add session data.
app.io.route('ready', function(req) {
    req.session.name = req.data
    req.session.save(function() {
        req.io.emit('get-feelings')
    })
})

// Send back the session data.
app.io.route('send-feelings', function(req) {
    req.session.feelings = req.data
    req.session.save(function() {
        req.io.emit('session', req.session)
    })
})

app.listen(7076)
