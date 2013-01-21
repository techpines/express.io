app = require('../../../express.io')()
app.http().io()

count = 0

app.io.route('posts', {
    create: function(req) {
        count += 1
        req.data.id = count
        app.io.broadcast('posts:create', req.data)
    },
    remove: function(req) {
        app.io.broadcast('posts:remove', req.data)    
    }
})

// Send the client html.
app.get('/', function(req, res) { 
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
