
## Simple HTTP + IO Setup

This is the canonical express.io example.  It does nothing, except set up 
an HTTP server and an IO server together.

#### Server (app.js)

[Get the code.](https://github.com/techpines/express.io/tree/master/examples/http-io)

```js
app = require('express.io')()
app.http().io()

// build realtime-web app

app.listen(7076)
```
