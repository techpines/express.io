
app = require('../../../express.io')()
app.http().io()

app.get('/', function(req, res) {
    app.io.broadcast('hello', {
        everybody: 'gets this'
    })

    app.io.room('nerds').broadcast('girls', {
        all: 'of the nerds get this'
    })
    res.sendfile(__dirname + '/client.html')
})

app.io.route('chirp', function(req) {
    req.io.join('nerds')
    req.io.emit('wait', {
        this: 'message goes back to the original socket'
    })

    req.io.broadcast('hey', {
        'this event': 'goes to every socket except the original'
    })
    
    req.io.room('creeps').broadcast('hey', {
        'only goes': 'to creeps'    
    })
})

app.listen(7076)
