class RubyCodeLauncher
	setSocket : (@socket) ->

	start: (code) ->
		console.log 'Code to execute is : ' + code

	stop: ->
		console.log 'Stop execution code asked'
		@socket.emit 'stdout', 'stdout from ruby'
		@socket.emit 'stderr', 'stderr from ruby'

	stdin: (input) ->
		console.log 'input is : ' + input

module.exports = RubyCodeLauncher