socket = undefined
prefix = '.present ' #the class that represent current slide

#Main function
RR_Main = ->
	socket = io.connect 'http://localhost:8080'
	RR_SetupInteractionZone()
	RR_BindEventListener()

#Add button, stdin and stdout zone
RR_SetupInteractionZone = ->
	interactionZone = '<div class="RR_InteractionZone">
			<button class="RR_RunButton">Run</button>
			<button class="RR_StopButton">Stop</button>
			<button class="RR_ClearButton">Clear</button>

			<p>Output :</p>
			<pre class="RR_Stdout"></pre>

			<input type="text" class="RR_Stdin">
		</div>'
	$('.RR_RubyCode').parent().after(interactionZone)

#Add text in the output zone
RR_AppendText = (txt, newline) ->
	msg = $(prefix + '.RR_Stdout').html() + txt
	msg += '\n' if newline == true
	$(prefix + '.RR_Stdout').html(msg)
	$(prefix + '.RR_Stdin').val("")

#Bind event listener for client and server event
RR_BindEventListener = ->
	#Event from client/user)
	$('.RR_RunButton').click RR_RunEvent
	$('.RR_StopButton').click RR_StopEvent
	$('.RR_Stdin').keydown (e) ->
		if e.keyCode == 13
			RR_StdinEvent()
			RR_AppendText $(prefix + '.RR_Stdin').val(), true
	$('.RR_ClearButton').click ->
		$(prefix + '.RR_Stdout').html('')
	#Events from server
	socket.on 'stdout', (output) ->
		RR_AppendText output
	socket.on 'stderr', (output) ->
		RR_AppendText output
	socket.on 'terminated', (message) ->
		RR_AppendText message, true

#Ask server to run a ruby code
RR_RunEvent = ->
	socket.emit 'run', $(prefix + '.RR_RubyCode').text()

#Ask server to stop current ruby script execution
RR_StopEvent = ->
	socket.emit 'stop'
#Send latest input to stdin or the current ruby script
RR_StdinEvent = ->
	socket.emit 'stdin', $(prefix + '.RR_Stdin').val()

#Load jquery and call main function.
RR_LoadJQuerry = ->
	headTag = document.getElementsByTagName("head")[0]
	jqTag = document.createElement 'script'
	jqTag.type = 'text/javascript'
	jqTag.src = 'https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js'
	jqTag.onload = ->
		$(RR_Main)
	headTag.appendChild jqTag

#Load jQuerry if needed, or call main function.
if typeof jQuery == 'undefined'
	RR_LoadJQuerry()
else
	$(RR_Main)