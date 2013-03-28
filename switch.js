
try {
    module.exports = require('./compiled');
} catch(error) {
    require('./node_modules/coffee-script');
    module.exports = require('./lib');
}

