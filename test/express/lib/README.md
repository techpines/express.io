
# API Reference

This gives details on the new top level objects for __express.io__.   

## ExpressIO

```js
express = require('express.io')
```

### Properties

* `express()` - Creates a new app object.
* `express.io` - The socket.io object.

## ExpressApp

```js
app = require('express.io')()
```

### Properties

* `app.http()` - starts an http server, returns `app`
* `app.https(options)` - starts an https server, returns `app`
* `app.io()` - starts an io server, returns `app`

For a complete list of properties, please check the [docs](http://expressjs.com/api.html#app.set).

## AppIO 

The io object for the entire app.  Used for routing and broadcasting to clients.

```js
app.io.broadcast('hey', {this: 'goes to everyone!'})
app.io.room('hipster').broadcast('meh', {this: 'goes to all hipsters'})
app.io.route('special', function(req) {
    // do something with req
})
```

You can also use the `AppIO` object to configure your io server.  For available options, check [here](https://github.com/LearnBoost/Socket.IO/wiki/Configuring-Socket.IO).

```js
app.io.configure(function() {
    app.io.enable('browser client minification');  // send minified client
    app.io.enable('browser client gzip');          // gzip the file
    app.io.set('log level', 1);                    // reduce logging
})
```

__Note__:  You must call `app.io()` before using.

### Properties

* `app.io.brodcast(event, data)` - Broadcast the `event` and `data` to all clients.
* `app.io.room(room).broadcast(event, data)` - Broadcast the `event` and `data` only to clients in the `room`.
* `app.io.route(event, callback)` - Takes a `route` name and a `callback`.  The callback passes `req`, which is a `SocketRequest` object.
* `app.io.set(property, value)` - Set a global io server property.
* `app.io.enable(property)` - Enable an io server feature.
* `app.io.configure(environment)` - Similar to the `app.configure` method for express.

## SocketRequest

This object is passed to the io routes.

```js
app.io.route('hello', function(req) {
    // do something with req
})
```

### Properties

* `req.data` - The `data` sent from the client request.
* `req.io` - The `RequestIO` object for the request.
* `req.headers` - `headers` from the initial web socket request.
* `req.session` - If you have sessions, then this is the express `session` object.
* `req.handshake` - This is the io `handshake` data.
* `req.socket` - The actual socket.io `socket`. Please use `req.io` instead.

## RequestIO

This object comes with the `SocketRequest`, and it gives you access to the request io.

```js
app.io.route('example', function(req) {
    req.io.emit('event', {this: 'is sent as an event to the client'})
    req.io.broadcast('shout-out', {this: 'goes to every client, except this one'})
    req.io.respond({sends: 'this data back to the client as an acknowledgment'})
    req.io.join('hipster') // joins the hipster room
    req.io.leave('hipster') // leaves the hipster room
    req.io.room('hipster').broadcast('hey', {this: 'goes to every hipster'})
    req.io.route('some-other-route')
     
})
```

### Properties

* `req.io.emit(event, data)` - Send an `event` with `data` to this client.
* `req.io.respond(data)` - Sends the acknowledgment `data` back to the client.
* `req.io.broadcast(event, data)` - Broadcast to all clients except this one.
* `req.io.room(room).broadcast(event,data)` - Broadcast to the specified `room`, the `event` and `data`.  Every client in the `room` except the one making the request, receives this `event`.
* `req.io.join(room)` - Make the client join the specified `room`.
* `req.io.leave(room)` - Make the client leave the specified `room`.
* `req.io.route(route)` - Forwards the `req` to the given `route`.

### Reserved Events

These events are reserved and should not be used with `app.io.route` or `req.io.on` unless you know what you are doing.

* `connect`
* `connecting`
* `disconnect`
* `connect_failed`
* `error`
* `message`
* `reconnect_failed`
* `reconnect`
* `reconnecting`

View the docs for [details on these events.](https://github.com/LearnBoost/socket.io/wiki/Exposed-events)

