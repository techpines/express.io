
app = require('../../../express.io')()
app.http().io()

// Initial web request.
app.get('/', function(req, res) {
    // Forward to an io route.
    req.io.route('hello')  
})

// Initial web request.
app.get('/blue-cheese', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.io.route('hello', function(req) {
    // Forward io request route to another io request.
    req.io.route('hello-again')
})

// Response from io request.
app.io.route('hello-again', function(req) {
    req.io.respond({hello: 'from io route'})
})

app.listen(7076)

