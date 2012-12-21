
express = require('express.io')
MongoStore = require('socket.io-mongo')
mongoUrl = 'mongodb://localhost:27017/yourdb'

cluster = require('cluster')
numCPUs = require('os').cpus().length;

// This is what the workers will do.
workers = function() {
    app = express().http().io()

    app.io.set('store', new MongoStore({url: mongoUrl}))

    // TODO: build realtime-web app

    app.listen(7076)
}

// Start forking if you are the master
if (cluster.isMaster) {
    for (var i = 0; i < numCPUs; i++) { cluster.fork() } 
} else { workers() }


