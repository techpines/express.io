# express.io
the realtime-web framework for node.js

```coffeescript
express.io = express + socket.io
```

## Simple App Setup

```javascript
app = require 'express.io'
app.http().io()

//build your realtime-web app

app.listen 7076
```

Now you use:

```javascript
app // the app object from express
app.io // the io object from socket.io
```

