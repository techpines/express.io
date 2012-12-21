
express = require('express.io')
redis = require('redis')
RedisStore = express.io.RedisStore

// This is what the workers will do.
workers = function() {
    app = express().http().io()

    app.io.set('store', new express.io.RedisStore({
        redisPub: redis.createClient(),
        redisSub: redis.createClient(),
        redisClient: redis.createClient()
    }))

    app.io.route('hey', function(req) {
        req.socket.broadcast.emit('shout-out', process.pid) 
    })
    
    app.get('/', function(req, res) {
        res.sendfile(__dirname + '/client.html')
    })

    app.listen(7076)
}

// Grab the cluster module and cpu number
cluster = require('cluster')
numCPUs = require('os').cpus().length;

// Start forking if you are the master
if (cluster.isMaster) {
    for (var i = 0; i < numCPUs; i++) {
        cluster.fork();
    }
} else { workers() }
