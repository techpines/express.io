

module.exports = (next) ->
    app = require('../lib/index')()
    app.http().io()

    app.io.route 'test-respond', (request) ->
        request.io.respond 'respond works'

    app.io.route 'test-emit', (request) ->
        resuest.io.emit 'emit works'

    app.listen ->
        next app
