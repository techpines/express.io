app = require('express.io')()
app.http().io()

// Setup the ready route, join room and broadcast to room.
app.io.route('ready', function(req) {
    req.io.join(req.data)
    req.io.room(req.data).broadcast('announce', {
        message: 'New client in the ' + req.data + ' room. '
    })
})

// Send the client html.
app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
