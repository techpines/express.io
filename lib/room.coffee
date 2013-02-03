
class exports.RoomIO
    constructor: (name, socket) ->
        @name = name
        @socket = socket
    broadcast: (event, message) ->
        if @socket.broadcast?
            @socket.broadcast.to(@name).emit event, message
        else
            @socket.in(@name).emit event, message
