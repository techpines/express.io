# express.io
the realtime-web framework for node.js

```coffeescript
express.io = express + socket.io
```

## Simple App Setup

```javascript
app = require('express.io')
app.http().io()

//build your realtime-web app

app.listen(7076)
```

Now you use:

```javascript
app // the app object from express
app.io // the io object from socket.io
```

## Routes for your Web Sockets
```javascript
app.io.route 'hello', (request) ->
    request.io.emit 'hello', 'world'
```

And Express Sessions 'just work'
```javascript
app.use(express.session({secret: 'dont-tell-nobody'}))

app.io.route 'get-my-session', (request) ->
    request.io.emit 'got-your-session', request.session
```

## Recipes

Here's some short easy recipes to get you started.

### Socket.io server with HTTPS

This is how you use https.

```javascript
options = {
    key: fs.readFileSync('key.pem'), 
    cert: fs.readFileSync('cert.pem')
}

app = require('express.io')
app.https(options).io()

//build your realtime-web app

app.listen(7076)
```

### Socket.io server with Sessions

This is how you set up sessions.

```javascript
express = require('express.io')

app = express()
app.https(options).io()

app.use express.sessions()

//build your realtime-web app

app.listen(7076)
```

### Upgrade your Regular Express App

Replace this in your existing code:

```javascript
require('express')
```

with this

```javascript
require('express.io')
```

Everything should work just as before, except now you're ready for socket.io!

## License
It's free! Party with the MIT!

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
