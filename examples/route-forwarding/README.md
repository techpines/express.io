## Route Forwarding

__This is a copy-paste example.__ 

The "middleware" style of routing is not a very good fit for io requests.  A typical io request does not need a response, so instead of "middleware", __express.io__ offers a robust system based on __route forwarding__.  Route forwarding can allow for a variety of rich, complex realtime interactions.

To forward a request, you use `req.io.route(route)`.

In this example, a route is a passed from an initial web request through two io routes, until finally back to the user.  If you go to `localhost:7076` you should see a simple json request returned.


#### Server (app.js)

```js
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
```

__Note__: When you forward http requests to io routes, `req.io.respond(data)` will call `res.json(data)` on the actual http request.  This  makes sense because http routes require a response, and the `respond` method is supposed to be a response for the given request.

Also, depending on the sophistication needed between a socket request and a web request, you might consider writing your own custom middleware layer and overriding `req.io.route` for your web requests.

