
express = require('../lib');
redis = require('redis');
RedisStore = require('connect-redis')(express);
redisStore = new RedisStore({client: redis.createClient()})

app = express();
app.http().io();

app.use(express.cookieParser());
app.use(express.session({
  secret: 'koho',
}));



app.get('/', function(request, response) {
return response.render('./client.html');
});

