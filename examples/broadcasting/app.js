
app = require('express.io')()
app.http().io()

app.io.route('ready', function(req) {
    req.io.broadcast('new visitor')
})

app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
