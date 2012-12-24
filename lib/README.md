
# Express.io API Reference

## Express Object

```js
express = require('express.io')
```

### New Properties

* `express.io` - is the socket.io object

Otherwise refer to the express docs:

[Express Docs](http://expressjs.com/api.html)

## ExpressApp

```js
app = require('express.io')()
```

### New Methods

* `app.http()` - starts an http server, returns `app`
* `app.https(options)` - starts an https server, returns `app`
* `app.io()` - starts a socket.io server, returns `app`

## AppIO 

The io object for the entire app.  Used to manage and manipulate clients.

```js
app.io.broadcast('hey', {this: 'goes to everyone!'})
app.io.room('hipster').broadcast('meh', {this: 'goes to all hipsters'})
app.io.route('special', function(req) {
    // do something with req
})
```

__Note__:  You must call `app.io()` before using.

### Properties

* `app.io.brodcast(event, data)` - Broadcast the `event` and `data` to all clients.
* `app.io.room(room).broadcast(event, data)` - Broadcast the `event` and `data` only to clients in the `room`.
* `app.io.route(event, callback)` - Takes a `route` name and a `callback`.  The callback passes `req`, which is a SocketRequest object.
* `app.io.set(property, value)` - Set a global socket.io property.
* `app.io.configure(environment)` - Similar to the `app.configure` method for express.

## SocketRequest

This object appears in the socket.io routes.

```js
app.io.route('hello', function(req) {
    req.data
    req.io
    req.headers
    res.session
    req.handshake
    req.socket
})
```

### Properties

* `req.data` - The `data` sent from the client request.
* `req.io` - The simple socket for the request.
* `req.headers` - `headers` from the initial web socket request.
* `req.session` - If you have sessions, then this is the express `session` object.
* `req.handshake` - This is the socket.io `handshake` data.
* `req.socket` - The actual socket.io `socket`. Please use `req.io` instead.

## RequestIO

```js
app.io.route('example', function(req) {
    req.io.emit('event', {this: 'is sent as an event to the client'})
    req.io.broadcast('shout-out', {this: 'goes to every client, except this one'})
    req.io.respond({sends: 'this data back to the client as an acknowledgment'})
    req.io.join('hipster') // joins the nerds room
    req.io.leave('hipster') // leaves the nerds room
    req.io.room('hipster').broadcast('hey', {this: 'goes to every hipster'})
     
})
```

### Properties

* `req.io.emit(event, data)` - Send an `event` with `data` to this client.
* `req.io.respond(data)` - Sends the acknowledgment `data` back to the client.
* `req.io.broadcast(event, data)` - Broadcast to all clients except this one.
* `req.io.room(room).broadcast(event,data)` - Broadcast to the specified `room`, the `event` and `data`.  Every client in the `room` except the one making the request, receives this `event`.
* `req.io.join(room)` - Make the client join the specified `room`.
* `req.io.leave(room)` - Make the client leave the specified `room`.

### Reserved Events

* `connect`
* `connecting`
* `disconnect`
* `connect_failed`
* `error`
* `message`
* `reconnect_failed`
* `reconnect`
* `reconnecting`

View the socket.io docs for [details on these events.](https://github.com/LearnBoost/socket.io/wiki/Exposed-events)


