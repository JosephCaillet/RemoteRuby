socket = undefined
prefix = '.present ' #the class that represent current slide

#Main function
RR_Main = ->
	$('head').append('<link rel="stylesheet" href="plugin/remote-ruby/remote-ruby.css" type="text/css" />');
	socket = io.connect 'http://localhost:8080'
	RR_SetupInteractionZone()
	RR_BindEventListener()

#Add button, stdin and stdout zone
RR_SetupInteractionZone = ->
	interactionZoneBegin = '<div class="RR_InteractionZone">
			<button class="RR_RunButton">Run</button>
			<button class="RR_StopButton">Stop</button>
			<button class="RR_ClearButton">Clear</button>

			<pre class="RR_Stdout"></pre>'

	interactionZoneStdinButton = '<input type="text" class="RR_Stdin" placeholder="Input goes here">'
	interactionZoneEnd = '</div>'

	$('.RR_RubyCode').each ->
		if $(this).hasClass("RR_FullIO")
			$(this).parent().after(interactionZoneBegin + interactionZoneStdinButton + interactionZoneEnd)
		else
			$(this).parent().after(interactionZoneBegin + interactionZoneEnd)

#Get current slide
RR_GetCurrentSlide = (selector) ->
	if $('.stack'+prefix + '>' + prefix).html() != undefined
		console.log("sub: " + selector)
		return $('.stack' + '>' + prefix + selector)
	else
		console.log("non: " + selector)
		return $(prefix + selector)

	###
	currentSlide = $('.stack' + '>' + prefix + selector)
	#console.log("2:"+prefix + '>' + prefix + selector)
	if currentSlide.html() == undefined
		currentSlide = $(prefix + selector)
		console.log("non: " + selector)
	else
		console.log("sub: " + selector)

	#console.log(currentSlide)
	console.log("------")
	return currentSlide
    ###

#Add text in the output zone
RR_AppendText = (txt, newline) ->
	msg = RR_GetCurrentSlide('.RR_Stdout').html() + txt
	#msg = $(prefix + '.RR_Stdout').html() + txt
	msg += '\n' if newline == true
	#stdout = $(prefix + '.RR_Stdout')
	stdout = RR_GetCurrentSlide('.RR_Stdout')
	stdout.html(msg)
	stdout.scrollTop(stdout.prop("scrollHeight"));

#Bind event listener for client and server event
RR_BindEventListener = ->
	#Event from client/user)
	$('.RR_RunButton').click RR_RunEvent
	$('.RR_StopButton').click RR_StopEvent
	$('.RR_Stdin').keydown (e) ->
		if e.keyCode == 13
			RR_StdinEvent()
	$('.RR_ClearButton').click ->
		#$(prefix + '.RR_Stdout').html('')
		RR_GetCurrentSlide('.RR_Stdout').html('')
	#Events from server
	socket.on 'stdout', (output) ->
		RR_AppendText output
	socket.on 'stderr', (output) ->
		RR_AppendText output
	socket.on 'terminated', (message) ->
		RR_AppendText message, true
		document.activeElement.blur();
	socket.on 'approvedInput', (input) ->
		#$(prefix + '.RR_Stdin').val("")
		RR_GetCurrentSlide('.RR_Stdin').val("")
		RR_AppendText input, true

#Ask server to run a ruby code
RR_RunEvent = ->
	###
	highlight.js is pretty cool, but it behave in a strange way when you try to edit code element,
    because it does not add newline character, which is very annoying for the ruby interpreter...
    that's why we change every div created by highlight.js with a div containing a br element,
    and we replace all br element with the newline character. This may create too much new line characters,
    but it's not a big problem. It's the only solution I have found, if you know an other let me know ;)
	###

	###
	console.log("1:"+ prefix + '>' + prefix + '.RR_RubyCode')
	rubyCodeHtml = $(prefix + '>' + prefix + '.RR_RubyCode').html()
	if rubyCodeHtml == undefined
		rubyCodeHtml = $(prefix + '.RR_RubyCode').html()
	###

	rubyCodeHtml = RR_GetCurrentSlide('.RR_RubyCode').html()
	#console.log(rubyCodeHtml)
	rubyCodeCloneElement = $('<div>').html( rubyCodeHtml )
	newContent = rubyCodeCloneElement.html().replace(/<div>/mg,"<div><br>").replace(/<br\s*\/?>/mg,"\n")
	rubyCodeCloneElement.html newContent
	#socket.emit 'run', $(prefix + '.RR_HiddenRubyCode').text() + rubyCodeCloneElement.text()
	socket.emit 'run', RR_GetCurrentSlide('.RR_HiddenRubyCode').text() + rubyCodeCloneElement.text()

#Ask server to stop current ruby script execution
RR_StopEvent = ->
	socket.emit 'stop'
#Send latest input to stdin or the current ruby script
RR_StdinEvent = ->
	#socket.emit 'stdin', $(prefix + '.RR_Stdin').val()
	socket.emit 'stdin', RR_GetCurrentSlide('.RR_Stdin').val()

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