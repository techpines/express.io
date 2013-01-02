app = require('../../../express.io')()
app.http().io()

app.io.use(function(data, next) {
    next('denied')
})

app.get('/', function(req, res) { 
    res.sendfile(__dirname + '/client.html')
})

app.listen(7076)
