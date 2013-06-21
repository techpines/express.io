express = require('express.io')
redis = require('socket.io/node_modules/redis')
RedisStore = express.io.RedisStore

// This is what the workers will do.
workers = function() {
    app = express().http().io()

    // Setup the redis store for scalable io.
    app.io.set('store', new express.io.RedisStore({
        redisPub: redis.createClient(),
        redisSub: redis.createClient(),
        redisClient: redis.createClient()
    }))

    // build realtime-web app

    app.listen(7076)
}

// Start forking if you are the master.
cluster = require('cluster')
numCPUs = require('os').cpus().length;

if (cluster.isMaster) {
    for (var i = 0; i < numCPUs; i++) { cluster.fork() } 
} else { workers() }
