
# Express.io API Reference

## Express Object

```js
express = require('express.io')
```
* `express.io` - is the socket.io object

Otherwise refer to the express docs:

[Express Docs](http://expressjs.com/api.html)

## Express App

```js
app = require('express.io')()
```

* `app.http()` - starts an http server
* `app.https(options)` - starts an https server
* `app.io()` - starts a socket.io server

## Socket.io Connection

```js
app.io // must initialize server before use
```

* `app.io.route(route, callback)` - Takes a route name and a callback.  The callback passes a socket.io request object.

## Socket.io Request Object

This object appears in the socket.io routes.

```js
app.io.route('hello', function(req) {
    console.log('Hi!, ' + req)
})
```

* `req.data` - the data sent from the socket
* `req.socket` - the socket for the request
* `req.headers` - headers form the initial request
* `req.session` - session object if available
* `req.handshake` - socket.io handshake data




