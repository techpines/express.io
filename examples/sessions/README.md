
## Sessions

__This is a copy-paste example.__ 

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
