
app = require('express.io')()
app.http().io()

// Setup the ready route.
app.io.route('ready', function(req) {
    // Send a talk event to the client.
    req.io.emit('talk', {
        message: 'io event from an io route on the server'
    })
})

// Send the client html.
app.get('/', function(req, res) { 
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
