
## Realtime Canvas

__This is a copy-paste example.__ 

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

