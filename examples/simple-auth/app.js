
express = require('express.io')
app = express().http().io()

// Setup the express session middleware.
app.use(express.cookieParser())
app.use(express.session({secret: 'shh'}))

// Setup our protected route.
app.io.route('make-changes', function(req) {
    // Check the session to see if the req is authenticated.
    if (req.session.authenticated) {
        console.log("cool it's authenticated")
    } else {
        console.log("um, not valid, disconnecting")
        req.socket.disconnect()
    }
})

// Send our client html down.
app.get('/', function(req, res) { 
    // Check a query string password.
    if (req.query.pass == 'swordfish') {
        req.session.authenticated = true
    }
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
