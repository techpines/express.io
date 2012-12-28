
app = require('express.io')()
app.http().io()

// Setup the ready route.
app.io.route('ready', function(req) {
    req.io.respond({
        success: 'here is your acknowledegment for the ready event'
    })
})

app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
