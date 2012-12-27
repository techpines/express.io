
app = require('../../../express.io')()
app.http().io()

app.get('/', function(req, res) {
    app.io.broadcast('new visitor')
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
