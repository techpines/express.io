
express = require('express.io')
redis = require('redis')
RedisStore = express.io.RedisStore

cluster = require('cluster')
numCPUs = require('os').cpus().length;

// This is what the workers will do.
workers = function() {
    app = express().http().io()

    app.io.set('store', new express.io.RedisStore({
        redisPub: redis.createClient(),
        redisSub: redis.createClient(),
        redisClient: redis.createClient()
    }))

    // build realtime-web app

    app.listen(7076)
}


// Start forking if you are the master
if (cluster.isMaster) {
    for (var i = 0; i < numCPUs; i++) { cluster.fork() } 
} else { workers() }

