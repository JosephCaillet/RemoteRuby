RR_Main = ->
	console.log "jQuerry loaded"

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