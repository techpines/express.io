
app = require('express.io')()
app.http().io()

app.io.route('ready', function(req) {
    room = req.data
    req.io.join(room)
    req.io.room(room).broadcast('announce', {
        message: 'new client in the ' + room + ' room'
    })
})

app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
