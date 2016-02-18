socket = undefined

RR_Main = ->
	console.log "jQuerry loaded"
	socket = io.connect 'http://localhost:8080'
	RR_BindEventListener()
	socket.on 'stdout', (output) ->
		RR_AppendText output
	socket.on 'stderr', (output) ->
		RR_AppendText output
	socket.on 'terminated', (message) ->
		RR_AppendText message, true

RR_LoadJQuerry = () ->
	headTag = document.getElementsByTagName("head")[0]
	jqTag = document.createElement 'script'
	jqTag.type = 'text/javascript'
	jqTag.src = 'https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js'
	jqTag.onload = ->
		$(RR_Main)
	headTag.appendChild jqTag

if typeof jQuery == 'undefined'
	RR_LoadJQuerry()
else
	$(RR_Main)

RR_AppendText = (txt, newline) ->
	msg = $('.RR_Stdout').html() + txt
	msg += '\n' if newline == true
	$('.RR_Stdout').html(msg)
	$('.RR_Stdin').val("")

RR_BindEventListener = ->
	$('.RR_RunButton').click RR_RunEvent
	$('.RR_StopButton').click RR_StopEvent
	$('.RR_Stdin').keydown (e) ->
		if e.keyCode == 13
			RR_StdinEvent()
			RR_AppendText $('.RR_Stdin').val(), true
	$('.RR_ClearButton').click ->
		$('.RR_Stdout').html('')

RR_RunEvent = ->
	socket.emit 'run', $('.RR_RubyCode').text()

RR_StopEvent = ->
	socket.emit 'stop'

RR_StdinEvent = ->
	socket.emit 'stdin', $('.RR_Stdin').val()