
app = require('express.io')()
app.http().io()

// Initial request with redirect.
app.get('/', function(req, res) {
    req.io.route('hello')  
})

// First redirect from web route to io route.
app.io.route('hello', function(req) {
    req.io.route('goodbye')
})

// Second redirect from io route to io route.
app.io.route('goodbye', function(req) {
    req.io.respond({hello: 'from io route'})
})

app.listen(7076)
