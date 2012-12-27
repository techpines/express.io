
app = require('../../../express.io')()
app.http().io()

app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.get('/shout-out', function(req, res) {
    app.io.room('users').broadcast('hey', {
        guys: 'i love you'
    })  
})

app.io.route('ready', function(req) {
    req.io.join('users')
    req.io.room('users').broadcast('hey', {
        guys: 'you are all very cool'
    })
})

app.io.route('hi-users', function(req) {
})

app.listen(7076)
