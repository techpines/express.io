app = require('express.io')()
app.http().io()

// Initial web request.
app.get('/', function(req, res) {
    // Forward to an io route.
    req.io.route('hello')  
})

// Forward io route to another io route.
app.io.route('hello', function(req) {
    req.io.route('hello-again')
})

// Sends response from io route.
app.io.route('hello-again', function(req) {
    req.io.respond({hello: 'from io route'})
})

app.listen(7076)
