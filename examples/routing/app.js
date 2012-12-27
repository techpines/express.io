
app = require('express.io')()
app.http().io()

app.io.route('hello', function(req) {
    console.log('Socket says ' + req.body.hello)
})

app.get('/', function(req, res) { 
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
