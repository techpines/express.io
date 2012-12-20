# express.io
the realtime-web framework for node.js

```coffeescript
express.io = express + socket.io
```

## Simple App Setup

```javascript
app = require('express.io')
app.http().io()

//build your realtime-web app

app.listen(7076)
```

## Upgrade your existing Express apps with Socket.io

Simply replace this line of code

```javascript
require('express')
```

with this line of code

```javascript
require('express.io')
```

Your app should run just the same as before, except now you're ready for reatltime.

## Routes for Socket.io
```javascript
app.io.route 'hello', (request) ->
    request.io.emit 'hello', 'world'
```

and express sessions 'just work'

```javascript
app.use(express.session({secret: 'dont-tell-nobody'}))

app.io.route 'get-my-session', (request) ->
    request.io.emit 'got-your-session', request.session
```

## Recipes

Here's some short easy recipes to get you started.

### Socket.io server with HTTPS

This is how you use https.

```javascript
options = {key: 'key', cert: 'cert'}
app = require('express.io')
app.https(options).io()

//build your realtime-web app

app.listen(7076)
```

### Socket.io server with Sessions

This is how you set up sessions.

```javascript
express = require('express.io')

app = express()
app.https(options).io()

app.use express.sessions()

//build your realtime-web app

app.listen(7076)
```

## A bunch of Socket.io Examples

### Sending and receiving events.

Socket.IO allows you to emit and receive custom events.

```js
// note, io.listen(<port>) will create a http server for you
app = require('express.io')
app.http().io()


app.get('/', function(request, response) {
    app.io.sockets.emit('this', { will: 'be received by everyone'})
    response.send('sockets are rockin')
})

app.io.route('private message', function(request) {
    console.log('I received a private message by ', request.io, ' saying ', request.body)
})

app.listen(7076)
```


### Storing data associated to a client

Sometimes it's necessary to store data associated with a client that's
necessary for the duration of the session.

#### Server side

```js
app = require('express.io')
app.http().io()

io.sockets.on('connection', function (socket) {
  socket.on('set nickname', function (name) {
    socket.set('nickname', name, function () { socket.emit('ready'); });
  });

  socket.on('msg', function () {
    socket.get('nickname', function (err, name) {
      console.log('Chat message by ', name);
    });
  });
});
```

#### Client side

```html
<script>
  var socket = io.connect('http://localhost');

  socket.on('connect', function () {
    socket.emit('set nickname', prompt('What is your nickname?'));
    socket.on('ready', function () {
      console.log('Connected !');
      socket.emit('msg', prompt('What is your message?'));
    });
  });
</script>
```

### Sending volatile messages.

Sometimes certain messages can be dropped. Let's say you have an app that
shows realtime tweets for the keyword `bieber`. 

If a certain client is not ready to receive messages (because of network slowness
or other issues, or because he's connected through long polling and is in the
middle of a request-response cycle), if he doesn't receive ALL the tweets related
to bieber your application won't suffer.

In that case, you might want to send those messages as volatile messages.

#### Server side

```js
app = require('express.io')
app.http().io()

io.sockets.on('connection', function (socket) {
  var tweets = setInterval(function () {
    getBieberTweet(function (tweet) {
      socket.volatile.emit('bieber tweet', tweet);
    });
  }, 100);

  socket.on('disconnect', function () {
    clearInterval(tweets);
  });
});

app.listen(7076)
```

#### Client side

In the client side, messages are received the same way whether they're volatile
or not.

### Getting acknowledgements

Sometimes, you might want to get a callback when the client confirmed the message
reception.

To do this, simply pass a function as the last parameter of `.send` or `.emit`.
What's more, when you use `.emit`, the acknowledgement is done by you, which
means you can also pass data along:

#### Server side

```js
app = require('express.io')
app.http().io()

app.io.route 'ferret', (name, next) ->
    next('woot')

app.listen(7076)
```

#### Client side

```html
<script>
  var socket = io.connect(); // TIP: .connect with no args does auto-discovery
  socket.on('connect', function () { // TIP: you can avoid listening on `connect` and listen on events directly too!
    socket.emit('ferret', 'tobi', function (data) {
      console.log(data); // data will be 'woot'
    });
  });
</script>
```

### Broadcasting messages

To broadcast, simply add a `broadcast` flag to `emit` and `send` method calls.
Broadcasting means sending a message to everyone else except for the socket
that starts it.

#### Server side

```js
app = require('express.io')
app.http().io()

app.io.route('announce', function(request) {
    request.io.broadcast('user connected');
    request.io.broadcast.json.send({a: 'message'})
});

app.listen(7076)
```

### Rooms

Sometimes you want to put certain sockets in the same room, so that it's easy
to broadcast to all of them together.

Think of this as built-in channels for sockets. Sockets `join` and `leave`
rooms in each socket.

#### Server side

```js
app = require('express.io')
app.http().io()

io.sockets.on('connection', function (socket) {
  socket.join('justin bieber fans');
  socket.broadcast.to('justin bieber fans').emit('new fan');
  io.sockets.in('rammstein fans').emit('new non-fan');
});

app.listen(7076)
```

### Using it just as a cross-browser WebSocket

If you just want the WebSocket semantics, you can do that too.
Simply leverage `send` and listen on the `message` event:

#### Server side

```js
var io = require('socket.io').listen(80);

io.sockets.on('connection', function (socket) {
  socket.on('message', function () { });
  socket.on('disconnect', function () { });
});
```

#### Client side

```html
<script>
  var socket = io.connect('http://localhost/');
  socket.on('connect', function () {
    socket.send('hi');

    socket.on('message', function (msg) {
      // my msg
    });
  });
</script>
```

### Changing configuration

Configuration in socket.io is TJ-style:

#### Server side

```js
var io = require('socket.io').listen(80);

io.configure(function () {
  io.set('transports', ['websocket', 'flashsocket', 'xhr-polling']);
});

io.configure('development', function () {
  io.set('transports', ['websocket', 'xhr-polling']);
  io.enable('log');
});
```

## License
It's free! Party with the MIT!

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
