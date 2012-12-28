
## Routing

__This is a copy-paste example.__ 

Express.io comes with a simple io routing system.  Use `app.io.route` by providing a `route` and a `callback`.  The `callback` receives a   [SocketRequest](https://github.com/techpines/express.io/tree/master/lib#socketrequest) object.

The philosophy behind the routing system is that it should be simple, flexible, and high performance.

When you run this example, go to your browser on `localhost:7076`, and you should see an alert message pop up, that is triggered by the io  route.


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

