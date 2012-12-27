
app = require('express.io')()
app.http().io()

app.io.route('ready', function(req) {
    req.io.join('users')
    req.io.room('users').broadcast('hey', {
        guys: 'you are all very cool'
    })
})

app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
