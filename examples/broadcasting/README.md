
## Broadcasting

__This is a copy-paste example__

You can easily broadcast messages to all your connected io clients.  There are two primary ways to broadcast a message using __express.io__:

* `app.io.broadcast(event, data)` - Will send the `event` and `data` to all connected clients.
* `req.io.broadcast(event, data)` - Will send the `event` and `data` to all connected clients except the client associated with the request.

For this example, pop open two browser windows to `localhost:7076`, then click refresh about five or six times on the second window, while  watching what happens in the first window.


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
