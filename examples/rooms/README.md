
## Rooms

__This is a copy-paste example.__ 

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
