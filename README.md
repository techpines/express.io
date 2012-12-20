# express.io
the realtime-web framework for node.js

```coffeescript
express.io = [express + socket.io]
```

## Why did I build this?

Express is awesome, and socket.io is awesome.   Sometimes they don't play nicely.  

```javascript
app = require 'express.io'
app.http().io()

//build your realtime-web app

app.listen 7076
```


