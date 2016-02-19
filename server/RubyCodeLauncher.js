// Generated by CoffeeScript 1.4.0
(function() {
  var RubyCodeLauncher, spawn;

  spawn = require('child_process').spawn;

  RubyCodeLauncher = (function() {

    function RubyCodeLauncher() {}

    RubyCodeLauncher.prototype.ruby = void 0;

    RubyCodeLauncher.prototype.setSocket = function(socket) {
      this.socket = socket;
    };

    RubyCodeLauncher.prototype.start = function(code) {
      var _this = this;
      if (this.isRubyRunning()) {
        this.stop();
      }
      this.ruby = spawn('ruby', ['-e', code]);
      console.log(code);
      this.ruby.stdout.on('data', function(data) {
        return _this.socket.emit('stdout', data.toString());
      });
      this.ruby.stderr.on('data', function(data) {
        return _this.socket.emit('stderr', data.toString());
      });
      return this.ruby.on('close', function(code) {
        var msg;
        if (code === null) {
          msg = "Ruby script killed";
        } else {
          msg = "Terminated with code : " + code;
        }
        _this.socket.emit('terminated', msg);
        return _this.ruby = void 0;
      });
    };

    RubyCodeLauncher.prototype.stop = function() {
      if (this.isRubyRunning()) {
        this.ruby.kill();
        return this.ruby = void 0;
      }
    };

    RubyCodeLauncher.prototype.stdin = function(input) {
      if (this.isRubyRunning()) {
        this.ruby.stdin.write(input + '\n');
        this.socket.emit('approvedInput', input);
        return console.log(input);
      }
    };

    RubyCodeLauncher.prototype.isRubyRunning = function() {
      return this.ruby != null;
    };

    return RubyCodeLauncher;

  })();

  module.exports = RubyCodeLauncher;

}).call(this);
