
express = require('../../../express.io')
app = express().http().io()

app.use(express.io.routeForward({style: 'backbone'}))

app.io.route('collection', {
    read: function(req) {
        if (req.data.id) {
            req.respond(cache.get(req.data.id))
        } else {
            req.respond(cache.get())
        }
    },
    create: function(req) {
        cache.create(req.data)
        req.respond(req.data)
    },
    update: function(req) {
        cache.update(req.data)
        req.respond(req.data)
    },
    delete: function(req) {
        cache.delete(req.data.id)
        req.respond()
    }
})

app.listen(7076)
