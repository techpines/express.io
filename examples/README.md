
# Express.io Examples

All of our examples work on node 0.8.x.  To get started do the following:

```js
git clone git://github.com/techpines/express.io
cd express.io/examples
npm install
```

## Simple HTTP Server and Socket.io Server

```js
app = require('express.io')()
app.http().io()

// build realtime-web app

app.listen(7076)
```

## Simple HTTPS Server and Socket.io Server

```js
app = require('express.io')()
app.https({key: 'key', cert: 'cert'}).io()

// build realtime-web app

app.listen(7076)
```

## Simple Example Using Routes

#### Server
app = require('express.io')()
app.http().io()

app.io.route('hello', function(req) {
    console.log('Socket says ' + req.body.hello)
})

app.get('/', function(req, res) { 
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
#### Client

```html
<script src="/socket.io/socket.io.js"></script>
<script>
socket = io.connect()

socket.on('connect', function() {
    socket.emit('hello', {hello: 'client is happy'})
})
</script>
```
