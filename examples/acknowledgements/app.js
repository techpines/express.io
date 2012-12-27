
app = require('express.io')()
app.http().io()

app.io.route('chat', function(req) {
    console.log('Client says ' + req.data.message)
    req.io.respond({message: 'thanks for chatting over io'})
})

app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
