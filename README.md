RemoteRuby
==========
A nodejs server with a js client to execute ruby code on a remote server.
This is intended to be a reveal.js plugin for running ruby code in your slides.

Requirements
============
* nodejs
* Ruby

How to Use
==========
Server configuration
--------------------
* On your machine, go into `server/` folder
* Run: `npm install`
* Start the server: `node remote-ruby-server.js`

Client Configuration
--------------------
* Copy `client/remote-ruby.js` into `plugin/remote-ruby/remote-ruby.js`
* Add dependencies :
```javascript
Reveal.initialize({
    controls: true,
    progress: true,
    history: true,
    center: true,

    transition: 'slide', // none/fade/slide/convex/concave/zoom

    // Optional reveal.js plugins
    dependencies: [
        { src: 'lib/js/classList.js', condition: function() { return !document.body.classList; } },
        { src: 'plugin/markdown/marked.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
        { src: 'plugin/markdown/markdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
        { src: 'plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } },
        { src: 'plugin/zoom-js/zoom.js', async: true },
        { src: 'plugin/notes/notes.js', async: true },
        //Here are Remote Ruby dependencies : socket.io, whis is provided by the nodejs server, and the file copied earlier.
        ////////////////////////////////////////
        { src: 'http://localhost:8080/socket.io/socket.io.js', async: true, condition: function() { return !!document.querySelector( '.RR_RubyCode' ); } },
        { src: 'plugin/remote-ruby/remote-ruby.js', async: true, condition: function() { return !!document.querySelector( '.RR_RubyCode' );} }
        ////////////////////////////////////////
    ]
});
```
* Add the class "RR_RubyCode" to your code element (Notice that your code element must be in a pre element !) :
```html
<section>
    <h2>Ruby demo n°1</h2>
    <h3>Simple output...</h3>
    <pre><code class="hljs ruby RR_RubyCode" data-trim contenteditable>
puts "Hello World !"
    </code></pre>
</section>
```
Tip : add the class "ruby" to inform highlight.js that you are coding in ruby.

This html code will be transformed like this:
```html
<section class="present" style="top: 162.5px; display: block;">
    <h2>Ruby demo n°1</h2>
    <h3>Simple output...</h3>
    <pre><code class="hljs ruby RR_RubyCode" data-trim="" contenteditable="">
puts "Hello World !"
    </code></pre>
    <div class="RR_InteractionZone">
        <button class="RR_RunButton">Run</button>
        <button class="RR_StopButton">Stop</button>
        <button class="RR_ClearButton">Clear</button>
        <pre class="RR_Stdout"></pre>
    </div>
</section>
```
* If you want to send data to your running ruby script, add the class "RR_FullIO" :
```html
<section>
    <h2>Ruby demo n°2</h2>
    <h3>Using inputs...</h3>
    <pre><code class=" hljs ruby RR_RubyCode RR_FullIO" data-trim contenteditable>
STDOUT.sync = true
puts "What is your name ?"
name = gets.chomp
puts "Hello #{name} ! :)"
    </code></pre>
</section>
```
This html code will be transformed like this:
```html
<section class="present" style="top: 159.5px; display: block;">
    <h2>Ruby demo n°2</h2>
    <h3>Using inputs...</h3>
    <pre><code class="hljs ruby RR_RubyCode RR_FullIO" data-trim="" contenteditable="">
SSTDOUT.sync = true
puts "What is your name ?"
name = gets.chomp
puts "Hello #{name} ! :)"
     </code></pre>
     <div class="RR_InteractionZone">
     <button class="RR_RunButton">Run</button>
     <button class="RR_StopButton">Stop</button>
     <button class="RR_ClearButton">Clear</button>
     <pre class="RR_Stdout"></pre>
     <input type="text" class="RR_Stdin" placeholder="Input goes here"></div>
</section>
```
Notice that on the first line of our ruby script, there is the instruction `STDOUT.sync = true`. It's here to ask ruby to do not use buffered output. If outputs are buffered, your ruby script can be awaiting input, without you knowing it, because the text that ask you something is still in the buffer!
