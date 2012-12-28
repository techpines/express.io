app = require('express.io')()
app.http().io()

// Broadcast the new visitor event on ready route.
app.io.route('ready', function(req) {
    req.io.broadcast('new visitor')
})

// Send client html.
app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
