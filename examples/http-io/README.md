

## Simple HTTP + IO Setup

```
cd http-io
node app.js
```

This is the canonical express.io example.  It does nothing, except set up 
an HTTP server and an IO server together.

#### Server (app.js)

```js
app = require('express.io')()
app.http().io()

// build realtime-web app

app.listen(7076)
```
