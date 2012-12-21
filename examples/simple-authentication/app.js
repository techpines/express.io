
express = require('express.io')
app = express().http().io()

app.use(express.cookieParser())
app.use(express.session({secret: 'shh'}))

app.io.route('make-changes', function(req) {
    if (req.session.authenticated) {
        console.log('i am ready to make changes for this authenticated socket')
    } else {
        console.log('socket you dead')
        req.socket.disconnect()
    }
})

app.get('/', function(req, res) { 
    if (req.query.pass == 'swordfish') {
        req.session.authenticated = true
    }
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
