
RoomIO = require('./room').RoomIO

class exports.RequestIO
    constructor: (socket, request, io) ->
        @socket = socket
        @request = request
        @manager = io
    
    broadcast: (event, message) ->
        @socket.broadcast.emit(event, message)
    
    emit: (event, message) ->
        @socket.emit(event, message)
    
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
        @sockets.on.apply @socket, args

    disconnect: (callback) ->
        @socket.disconnect(callback)
