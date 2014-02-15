RoomIO = require('./room').RoomIO

class exports.RequestIO
    constructor: (socket, request, io) ->
        @socket = socket
        @request = request
        @manager = io
    
    broadcast: (event, message) ->
        @socket.broadcast.emit(event, message)
        
    emit: (event, message, cb) ->
        @socket.emit(event, message, cb)

    get: (key, cb) ->
      @socket.get(key, cb)

    set: (key, val, cb) ->
      @socket.set(key, val, cb)

    room: (room) ->
        new RoomIO(room, @socket)

    join: (room) ->
        @socket.join(room)

    route: (route) ->
        @manager.route route, @request, trigger: true

    leave: (room) ->
        @socket.leave(room)

    on: ->
        args = Array.prototype.slice.call arguments, 0
        @socket.on.apply @socket, args

    disconnect: (callback) ->
        @socket.disconnect(callback)
