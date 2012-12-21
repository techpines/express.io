
express = require('express.io')
app = express()
app.http().io()

// Setup your sessions.
app.use(express.cookieParser())
app.use(express.session({secret: 'monkey'}))

// Send back the client html.
app.get('/', function(req, res) {
    req.session.loginDate = new Date
    res.sendfile(__dirname + '/client.html')
})

// Setup a web socket route to set a nickname.
app.io.route('set nickname', function(req) {
    req.session.nickname = req.body
    console.log(req.session.nickname);
    req.session.save(function() {
        console.log('listen up')
        req.io.emit('ready')
    })
})

app.io.route('talk', function(req) {
    console.log(req.session)
    console.log(req.body)
    console.log('Message from ', req.session.nickname)
    console.log('It says "' + req.body + '"')
    console.log('Guy logged in at ' + req.session.loginDate)
})

app.listen(7076)
