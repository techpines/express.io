
app = require('../../../express.io')()
app.http().io()

app.get('/', function(req, res) {
    console.log(app.io)
    app.io.broadcast('new-user')
    app.io.broadcast.to('peeps').emit('cheese', {
        dick: 'willies'
    })
    peeps = app.io.room('peeps')
    peeps.broadcast('hey': you: 'rock')
    res.sendfile(__dirname + '/client.html')
})

app.io.route('poop', function(req) {
    console.log('*******************')
    console.log(req.io.broadcast)
    req.io.join('test')
    request.io.room('
    req.io.emit('hellow')
    req.io.room('test').broadcast('cheese', {
        dick: 'willies'
    })
    
})

app.listen(7076)
