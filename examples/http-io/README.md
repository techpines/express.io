## Simple HTTP + IO Setup

__This is a copy-paste example.__

This is the canonical __express.io__ example.  It does nothing, except set up
an HTTP server and an io server together on the same port.

When you run this example, the server should start.

#### Server (app.js)

```js
app = require('express.io')()
app.http().io()

// build realtime-web app

app.listen(7076)
```

