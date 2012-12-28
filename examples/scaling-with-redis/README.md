
## Scaling with Redis

__This is a copy-paste example, if redis dependencies installed.__ 

If you need to scale your io server past one process, (which hopefully you will).  Then you need to take advantage of a pub/sub server. Here is an example using Redis with multiple node processes.

To start, you might need to install redis, here are the [install docs](http://redis.io/topics/quickstart).

Once you have redis installed you need to install the redis node client.

```
npm install redis
```

When you run this example, if you have more than one processor, then you should see a log message from the io server for each process.

#### Server (app.js)

```js
express = require('express.io')
redis = require('redis')
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
```

