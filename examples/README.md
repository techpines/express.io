
# Express.io Examples

All of our examples work on node 0.8.x.  To get started do the following:

```bash
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

socket.emit('hello', {hello: 'client is happy'})

</script>
```

## Realtime Canvas

```bash
cd realtime-canvas
node app.js
```

#### Server

```js
express = require('express.io')
app = express().http().io()

// Static serve for drag and drop library.
app.use(express.static(__dirname))

// Broadcast all draw clicks.
app.io.route('drawClick', function(req) {
    req.socket.broadcast.emit('draw', req.body)
})

app.get('/', function(req, res) {
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
```

#### Client

```html
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript" src="/lib/jquery.event.drag-2.0.js"></script>
<script src="/socket.io/socket.io.js"></script>
<script>
    App = {}
    App.socket = io.connect()
    App.socket.on('draw', function(data) {
        App.draw(data.x, data.y, data.type)
    })
    // Init function.
    App.init = function() {
        App.ctx = $('canvas')[0].getContext("2d")
        App.ctx.fillStyle = "solid"        
        App.ctx.strokeStyle = "#bada55"    
        App.ctx.lineWidth = 5               
        App.ctx.lineCap = "round"
        $('canvas').live('drag dragstart dragend', function(e) {
            type = e.handleObj.type
            offset = $(this).offset()
            var x = e.clientX - offset.left
            var y = e.clientY - offset.top
            App.draw(x,y,type)
            App.socket.emit('drawClick', { x : x, y : y, type : type})
        })
    }         
    // Draw Function
    App.draw = function(x,y,type) {
        if (type == "dragstart") {
            App.ctx.beginPath()
            App.ctx.moveTo(x,y)
        } else if (type == "drag") {
            App.ctx.lineTo(x,y)
            App.ctx.stroke()
        } else {
            App.ctx.stroke()
            App.ctx.closePath()
        }
    }
    $(function() {
        App.init()
    })
</script>
<canvas width="800px", height="400px"></canvas>
```
