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

This might lead some people to wonder, when is it best to send an acknowledgement vs just emitting an event to the client.  It actually     doesn't matter, it's more of a code clarity thing.  Events are more flexible, because they can be triggered in a number of different ways,  whereas the acknowledgement is a straight response.

In a way, the acknowledgements are a little more old-fashioned, pushing you towards the "every request has a response" mentality of         traditional http.  Sometimes this is good, other times it's not.  Use common sense and just be consistent with whatever approach you take,  and you should be fine.
