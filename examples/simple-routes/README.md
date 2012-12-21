
## Simple Example Using Routes

#### Server

```js
app = require('express.io')()
app.http().io()

app.io.route('hello', function(req) {
    console.log('Socket says ' + req.body.hello)
})

app.get('/', function(req, res) { 
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
```

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
