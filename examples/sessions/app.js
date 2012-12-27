
express = require('express.io')
app = express().http().io()

// Setup your sessions.
app.use(express.cookieParser())
app.use(express.session({secret: 'monkey'}))

// Setup a route to get the sockets 'hey' event.
app.io.route('hey', function(req) {
    req.session.name = req.data
    req.session.save(function() {
        req.socket.emit('how are you?')
    })
})

// Make sure to 'chat' with the socket, it might be lonely.
app.io.route('chat', function(req) {
    req.session.feelings = req.data
    req.session.save(function() {
        req.socket.emit('cool', req.session)
    })
})

// Send back the client html.
app.get('/', function(req, res) {
    req.session.loginDate = new Date().toString()
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
