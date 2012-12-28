## Simple HTTPS + IO Setup

__This is a copy-paste example, if key and cert files present.__ 

This is the same as the HTTP example, but for HTTPS.  You have to pass the key and cert contents as an option.

When you run this example, the server should start.

#### Server (app.js)

```js
fs = require('fs')
options = {
    key: fs.readFileSync('./key'),
    cert: fs.readFileSync('./cert')
}

app = require('express.io')()
app.https(options).io()

// build realtime-web app

app.listen(7076)
```

