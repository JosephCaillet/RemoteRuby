spawn = require('child_process').spawn

class RubyCodeLauncher
	#represent the ruby process, undefined means iti is not running.
	ruby: undefined

	setSocket : (@socket) ->

	start: (code) ->
		@stop() if @isRubyRunning()

		@ruby = spawn 'ruby', ['-e', code]

		@ruby.stdout.on 'data', (data) =>
			@socket.emit 'stdout', data.toString()

		@ruby.stderr.on 'data', (data) =>
			@socket.emit 'stderr', data.toString()

		@ruby.on 'close', (code) =>
			if code == null
				msg = "Ruby script killed\n"
			else
				msg = "Terminated with code : " + code + "\n"
			@socket.emit 'terminated', msg
			@ruby = undefined

	stop: ->
		if @isRubyRunning()
			@ruby.kill()
			@ruby = undefined

	stdin: (input) ->
		if @isRubyRunning()
			@ruby.stdin.write input + '\n'
			@socket.emit 'approvedInput', input

	isRubyRunning: ->
		return @ruby?

module.exports = RubyCodeLauncher