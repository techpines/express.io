
express = require('express.io')
app = express().http().io()

// Setup your sessions.
app.use(express.cookieParser())
app.use(express.session({secret: 'monkey'}))

// Send back the client html.
app.get('/', function(req, res) {
    // Add login date to the session.
    req.session.loginDate = new Date().toString()
    res.sendfile(__dirname + '/client.html')
})

// Setup a route for the ready event.
app.io.route('ready', function(req) {
    req.session.name = req.data // add name to the session
    
    // save the session
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
