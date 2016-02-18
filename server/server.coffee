http = require 'http'
io = require 'socket.io'

server = http.createServer()
io = io.listen server

io.sockets.on 'connection', (socket) ->
	socket.on 'run', (code) ->
		console.log 'Code to execute is : \n' + code

	socket.on 'stop', ->
		console.log 'Stop execution code asked'
		socket.emit 'stdout', 'taaaaaaaataaaaaa yoyoooooooooooooooo'

	socket.on 'stdin', (input) ->
		console.log 'input is : ' + input

server.listen 8080