
# Express.io API Reference

## Express Object

```js
express = require('express.io')
```

### New Properties

* `express.io` - is the socket.io object

Otherwise refer to the express docs:

[Express Docs](http://expressjs.com/api.html)

## Express App

```js
app = require('express.io')()
```

### New Methods

* `app.http()` - starts an http server, returns `app`
* `app.https(options)` - starts an https server, returns `app`
* `app.io()` - starts a socket.io server, returns `app`

## App IO 

```js
app.io 
```

__Note__:  You must call `app.io()` before using.

### Properties

* `app.io.brodcast(event, data)` - 
* `app.io.route(event, callback)` - Takes a route name and a callback.  The callback passes a socket request object.  
* `app.io.room(room)` - gets the room

## Socket Request Object

This object appears in the socket.io routes.

```js
app.io.route('hello', function(req) {
    console.log('Hi!, ' + req)
})
```

### Properties

* `req.data` - the data sent from the socket
* `req.io` - the simple socket for the request
* `req.headers` - headers form the initial request
* `req.session` - session object if available
* `req.handshake` - socket.io handshake data
* `req.socket` - the socket for the request
* `req.respond(data)` - sends the acknowledgment 

## Simple Socket Object

```js
req.io
```

### Properties

* `req.io.broadcast(event, data)` - broadcast to all clients except this one
* `req.io.room(room)` - grab a room to broadcast to, similar to the method above
* `req.io.join(room)` - join a room
* `req.io.leave(room)` - leave a room
* `req.io.emit(event, data)` - send an event to this socket.
* `req.io.respond(data)` - send acknowledgment response back to socket

## Simple Room Object

The room object can be either from the AppIO object or it can be from a RequestIO.  If it is from the AppIO object then it would work like this:

```js
room = app.io.room('cheers')
room.broadcast('hey', {
    message: 'would go to everyone in this room'
})
```
If it's from the RequestIO object, then it would broadcast to everyone but itself.

```js
app.io.route('fun', function(req) {
    room = req.io.room('nerds')
    room.broadcast('new nerd', {
        this: 'will go to everyone except this client'
    })
})
```



