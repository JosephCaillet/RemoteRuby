spawn = require('child_process').spawn

class RubyCodeLauncher
	ruby: undefined

	setSocket : (@socket) ->

	start: (code) ->
		@stop() if @isRubyRunning()

		@ruby = spawn 'ruby', ['-e', code]

		@ruby.stdout.on 'data', (data) =>
			@socket.emit 'stdout', data.toString()
			console.log data.toString()

		@ruby.stderr.on 'data', (data) =>
			@socket.emit 'stderr', data

		@ruby.on 'close', (code) =>
			if code == null
				msg = "Ruby script killed"
			else
				msg = "Terminated with code : " + code
			@socket.emit 'terminated', msg

		console.log 'Code to execute is : ' + code

	stop: ->
		console.log 'Stop execution code asked'
		@ruby.kill() if @isRubyRunning()


	stdin: (input) ->
		console.log 'input is : ' + input
		if @isRubyRunning()
			@ruby.stdin.write input
			@ruby.stdin.end()

	isRubyRunning: ->
		return @ruby?

module.exports = RubyCodeLauncher