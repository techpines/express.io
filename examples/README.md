
# Examples

__All of these examples work__.  I repeat, __all of these examples work__.  Almost every example will work if copy and pasted.  These are working examples.  Just make sure you have `node` and `express.io` installed. :)

You can also run them straight out of the repository without copy-pasting, if you do the following.

```bash
git clone git://github.com/techpines/express.io
cd express.io/examples
npm install
```

Then `cd` into an example directory and run:

```bash
node app.js
```

## Simple HTTP + IO Setup

__This is a copy-paste example.__ [(get the code)](https://github.com/techpines/express.io/tree/master/examples/http-io)

This is the canonical __express.io__ example.  It does nothing, except set up 
an http server and an io server together on the same port.

When you run this example, the server should start.

#### Server (app.js)

```js
app = require('express.io')()
app.http().io()

// build realtime-web app

app.listen(7076)
```

## Simple HTTPS + IO Setup

__This is a copy-paste example, if key and cert files present.__ [(get the code)](https://github.com/techpines/express.io/tree/master/examples/https-io)

This is the same as the HTTP example, but for HTTPS.  You have to pass the key and cert contents as an option.

When you run this example, the server should start. 

#### Server (app.js)

```js
fs = require('fs')
options = {
    key: fs.readFileSync('./key'), 
    cert: fs.readFileSync('./cert')
} 

app = require('express.io')()
app.https(options).io()

// build realtime-web app

app.listen(7076)
```

## Routing

__This is a copy-paste example.__ [(get the code)](https://github.com/techpines/express.io/tree/master/examples/routing)

Express.io comes with a simple io routing system.  Use `app.io.route` by providing a `route` and a `callback`.  The `callback` receives a [SocketRequest](https://github.com/techpines/express.io/tree/master/lib#socketrequest) object.

The philosophy behind the routing system is that it should be simple, flexible, and high performance.

When you run this example, go to your browser on `localhost:7076`, and you should see an alert message pop up, that is triggered by the io route.


#### Server (app.js)

```js
app = require('express.io')()
app.http().io()

// Setup the ready route, and emit talk event.
app.io.route('ready', function(req) {
    req.io.emit('talk', {
        message: 'io event from an io route on the server'
    })
})

// Send the client html.
app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
```

#### Client (client.html)

```html
<script src="/socket.io/socket.io.js"></script>
<script>
io = io.connect()

// Emit ready event.
io.emit('ready') 

// Listen for the talk event.
io.on('talk', function(data) {
    alert(data.message)
})  

</script>
```

## Route Forwarding

__This is a copy-paste example.__ [(get the code)](https://github.com/techpines/express.io/tree/master/examples/route-forwarding)

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

__Note__: When you forward http requests to io routes, `req.io.respond(data)` will call `res.json(data)` on the actual http request.  This makes sense because http routes require a response, and the `respond` method is supposed to be a response for the given request.

Also, depending on the sophistication needed between a socket request and a web request, you might consider writing your own custom middleware layer and overriding `req.io.route` for your web requests.

## Middleware

Middleware only runs __ONCE__ during the initial io connection. This allows you to perform authentication, log things in your database, or anything else you can imagine.  It does not run on every subsequent io request.  

#### Server (app.js)

```
app = require('express.io')()

app.io.use(function(data, next) {
    next('screw you')
})

app.listen(7076)
```

## Broadcasting

__This is a copy-paste example__ [(get the code)](https://github.com/techpines/express.io/tree/master/examples/broadcasting)

You can easily broadcast messages to all your connected io clients.  There are two primary ways to broadcast a message using __express.io__:

* `app.io.broadcast(event, data)` - Will send the `event` and `data` to all connected clients.
* `req.io.broadcast(event, data)` - Will send the `event` and `data` to all connected clients except the client associated with the request.

For this example, pop open two browser windows to `localhost:7076`, then click refresh about five or six times on the second window, while watching what happens in the first window.


#### Server (app.js)

```js
app = require('express.io')()
app.http().io()

// Broadcast the new visitor event on ready route.
app.io.route('ready', function(req) {
    req.io.broadcast('new visitor')
})

// Send client html.
app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
```

#### Client (client.html)

```html
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script src="/socket.io/socket.io.js"></script>
<script>
io = io.connect()

// Send the ready event.
io.emit('ready')

// Listen for the new visitor event.
io.on('new visitor', function() {
    $('body').append('<p>New visitor, hooray! ' + new Date().toString() +'</p>')
})
</script>
```

## Sessions

__This is a copy-paste example.__ [(get the code)](https://github.com/techpines/express.io/tree/master/examples/sessions)

In __express.io__, sessions are shared between web requests and io requests.  This makes it a breeze to share a little state or perform authentication.  You setup your sessions exactly as you would with express, and all the magic is handled for you!

For this example, go to `localhost:7076`, and you will be prompted by a few questions, and the server will prove the sessions are working.

#### Server (app.js)

```js
express = require('express.io')
app = express().http().io()

// Setup your sessions, just like normal.
app.use(express.cookieParser())
app.use(express.session({secret: 'monkey'}))

// Session is automatically setup on initial request.
app.get('/', function(req, res) {
    req.session.loginDate = new Date().toString()
    res.sendfile(__dirname + '/client.html')
})

// Setup a route for the ready event, and add session data.
app.io.route('ready', function(req) {
    req.session.name = req.data
    req.session.save(function() {
        req.io.emit('get-feelings')
    })
})

// Send back the session data.
app.io.route('send-feelings', function(req) {
    req.session.feelings = req.data
    req.session.save(function() {
        req.io.emit('session', req.session)
    })
})

app.listen(7076)
```

#### Client (client.html)

```html
<script src="/socket.io/socket.io.js"></script>
<script>
  var socket = io.connect();

  // Emit ready event.
  socket.emit('ready', prompt('What is your name?'))

  // Listen for get-feelings event.
  socket.on('get-feelings', function () {
      socket.emit('send-feelings', prompt('How do you feel?'));
  })

  // Listen for session event.
  socket.on('session', function(data) {
      message = 'Hey ' + data.name + '!\n\n' 
      message += 'Server says you feel '+ data.feelings + '\n'
      message += 'I know these things because sessions work!\n\n'
      message += 'Also, you joined ' + data.loginDate + '\n'
      alert(message)
  })
</script>
```

__Note__: You need to save the session explicitly for io requests, because there is no guarantee of a response, unlike a normal http request.

## Rooms

__This is a copy-paste example.__ [(get the code)](https://github.com/techpines/express.io/tree/master/examples/rooms)

Sometimes you will want to group your io clients together into rooms.  With __express.io__ this is a breeze!  Here are the commands for dealing with rooms:

* `req.io.join(room)` - The client for the request joins `room`.
* `req.io.leave(room)` - The client for the request leaves `room`.
* `req.io.room(room).broadcast(event, data)` - Broadcast to all client in the room except for the current one.
* `app.io.room(room).brodcast(event, data)` - Broadcast to all clients in the room.

For this example, open two browser windows on `localhost:7076`.  You will be prompted to give a room name.  Enter the same room name for each browser, then check back with the first window to see the result.  

Also, try a third window with a different room name, and see your other windows miss the broadcast.

#### Server (app.js)

```js
app = require('express.io')()
app.http().io()

// Setup the ready route, join room and broadcast to room.
app.io.route('ready', function(req) {
    req.io.join(req.data)
    req.io.room(req.data).broadcast('announce', {
        message: 'New client in the ' + req.data + ' room. '
    })
})

// Send the client html.
app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
```

#### Client (client.html)

```html
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script src="/socket.io/socket.io.js"></script>
<script>
io = io.connect()
room = prompt('type a room name')

// Emit ready event with room name.
io.emit('ready', room)

// Listen for the announce event.
io.on('announce', function(data) {
    $('body').append('<p>'+data.message+ new Date().toString()+'</p>')
})

</script>
```

## Acknowledgements

__This is a copy-paste example.__ [(get the code)](https://github.com/techpines/express.io/tree/master/examples/acknowledgements)

Sometimes you need confirmation or acknowledgement from the server for an io request.  To respond from the server you need to call  `req.io.respond(data)`.

For this example, go to `localhost:7076` and you should get a pop-up from the acknowledgement. 

#### Server (app.js)

```js
app = require('express.io')()
app.http().io()

// Setup the ready route.
app.io.route('ready', function(req) {
    req.io.respond({
        success: 'here is your acknowledegment for the ready event'
    })
})

app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
```

#### Client (client.html)

```html
<script src="/socket.io/socket.io.js"></script>
<script>
io = io.connect()

// Emit ready event, and wait for acknowledgement.
io.emit('ready', {hey: 'server'}, function(data) {
    alert(data.success)
})
</script>
```

This might lead some people to wonder, when is it best to send an acknowledgement vs just emitting an event to the client.  It actually doesn't matter, it's more of a code clarity thing.  Events are more flexible, because they can be triggered in a number of different ways, whereas the acknowledgement is a straight response.

In a way, the acknowledgements are a little more old-fashioned, pushing you towards the "every request has a response" mentality of traditional http.  Sometimes this is good, other times it's not.  Use common sense and just be consistent with whatever approach you take, and you should be fine.

## Realtime Canvas

__This is a copy-paste example.__ [(get the code)](https://github.com/techpines/express.io/tree/master/examples/realtime-canvas)

This is a realtime canvas example.  It's really cool, and it works right of the box, so give it a try!

Open two browser windows on `localhost:7076`, then click and drag to draw in the first browser window, and you can see it draw in the second browser!

#### Server (app.js)

```js
express = require('express.io')
app = express().http().io()

// Broadcast all draw clicks.
app.io.route('drawClick', function(req) {
    req.io.broadcast('draw', req.data)
})

// Send client html.
app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
```

#### Client (client.html)

```html
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script src="//cdn.techpines.io/jquery.event.drag-2.0.js"></script>
<script src="/socket.io/socket.io.js"></script>
<script>
    App = {}
    App.socket = io.connect()

    // Draw Function
    App.draw = function(data) {
        if (data.type == "dragstart") {
            App.ctx.beginPath()
            App.ctx.moveTo(data.x,data.y)
        } else if (data.type == "drag") {
            App.ctx.lineTo(data.x,data.y)
            App.ctx.stroke()
        } else {
            App.ctx.stroke()
            App.ctx.closePath()
        }
    }

    // Draw from other sockets
    App.socket.on('draw', App.draw) 

    // Bind click and drag events to drawing and sockets.
    $(function() {
        App.ctx = $('canvas')[0].getContext("2d")
        $('canvas').live('drag dragstart dragend', function(e) {
            offset = $(this).offset()
            data = {
                x: (e.clientX - offset.left), 
                y: (e.clientY - offset.top),
                type: e.handleObj.type
            }
            App.draw(data) // Draw yourself.
            App.socket.emit('drawClick', data) // Broadcast draw.
        })
    })         
</script>
<canvas width="800px" height="400px" style="margin: 0 auto"></canvas>
```

## Scaling with Redis

__This is a copy-paste example, if redis dependencies installed.__ [(get the code)](https://github.com/techpines/express.io/tree/master/examples/scaling-with-redis)

If you need to scale your io server past one process, (which hopefully you will).  Then you need to take advantage of a pub/sub server.  Here is an example using Redis with multiple node processes.

To start, you might need to install redis, here are the [install docs](http://redis.io/topics/quickstart).

Once you have redis installed you need to install the redis node client.

```
npm install redis
```

When you run this example, if you have more than one processor, then you should see a log message from the io server for each process.

#### Server (app.js)

```js
express = require('express.io')
redis = require('redis')
RedisStore = express.io.RedisStore

// This is what the workers will do.
workers = function() {
    app = express().http().io()

    // Setup the redis store for scalable io.
    app.io.set('store', new express.io.RedisStore({
        redisPub: redis.createClient(),
        redisSub: redis.createClient(),
        redisClient: redis.createClient()
    }))

    // build realtime-web app

    app.listen(7076)
}

// Start forking if you are the master.
cluster = require('cluster')
numCPUs = require('os').cpus().length;

if (cluster.isMaster) {
    for (var i = 0; i < numCPUs; i++) { cluster.fork() }
} else { workers() }
```

## Scaling with Mongo

*Coming soon!*
