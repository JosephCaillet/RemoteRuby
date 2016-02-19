http = require 'http'
io = require 'socket.io'
Ruby = require './RubyCodeLauncher'

server = http.createServer()
io = io.listen server

ruby = new Ruby

io.sockets.on 'connection', (socket) ->
	ruby.setSocket socket
	socket.on 'run', (code) ->
		ruby.start code

	socket.on 'stop', ->
		ruby.stop()

	socket.on 'stdin', (input) ->
		ruby.stdin input

server.listen 8080