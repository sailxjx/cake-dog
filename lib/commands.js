// Generated by CoffeeScript 1.7.1
(function() {
  var coffeeCmd, colors, dump, dumpfile, e, exec, fork, fs, mkdirp, path, _checkWatcherStatus, _parseOptions, _ref, _removeWatcher;

  path = require('path');

  fs = require('fs');

  mkdirp = require('mkdirp');

  colors = require('colors');

  coffeeCmd = require('coffee-script/lib/coffee-script/command');

  _ref = require('child_process'), exec = _ref.exec, fork = _ref.fork;

  dumpfile = path.join(process.env.HOME, '.cakedog.json');

  try {
    dump = require(dumpfile);
  } catch (_error) {
    e = _error;
    dump = {};
  }

  _parseOptions = function(options) {
    var output, source;
    if (options == null) {
      options = {};
    }
    output = options.output, source = options.source;
    output || (output = process.cwd());
    source || (source = process.cwd());
    output = path.resolve(output);
    source = path.resolve(source);
    if (!fs.existsSync(source)) {
      mkdirp.sync(source);
    }
    options.source = source;
    options.output = output;
    return options;
  };

  _checkWatcherStatus = function(pid, callback) {
    return exec("ps -p " + pid + " | grep -v 'grep' | grep 'cake-dog'", function(err, result) {
      if ((err != null) || (result != null ? result.trim().length : void 0) < 1) {
        return callback('QUITED');
      } else {
        return callback('RUNNING');
      }
    });
  };

  _removeWatcher = function(source) {
    delete dump[source];
    return fs.writeFileSync(dumpfile, JSON.stringify(dump, null, 2));
  };

  exports.compile = function(options) {
    var a1, a2, output, source, _ref1, _ref2;
    if (options == null) {
      options = {};
    }
    _ref1 = _parseOptions(options), output = _ref1.output, source = _ref1.source;
    _ref2 = process.argv, a1 = _ref2[0], a2 = _ref2[1];
    process.argv = [a1, a2, '-o', output, '-c', source];
    coffeeCmd.run();
    return console.log('Compile finish'.green);
  };

  exports.watch = function(options, callback) {
    var output, pid, source, _ref1, _ref2, _watch;
    if (options == null) {
      options = {};
    }
    if (callback == null) {
      callback = function() {};
    }
    _ref1 = _parseOptions(options), output = _ref1.output, source = _ref1.source;
    pid = (_ref2 = dump[source]) != null ? _ref2.pid : void 0;
    _watch = function() {
      var child;
      process.chdir(source);
      child = fork(path.resolve(__dirname, 'fork'), ['-w', '-o', output, '-c', source]);
      dump[source] = {
        pid: child.pid,
        source: source,
        output: output
      };
      fs.writeFileSync(dumpfile, JSON.stringify(dump, null, 2));
      console.log(("Watching " + source + ", pid: " + child.pid).green);
      return callback();
    };
    if (pid == null) {
      return _watch();
    }
    return _checkWatcherStatus(pid, function(status) {
      switch (status) {
        case 'QUITED':
          console.warn(("Watcher " + pid + " was exited unexpectedly last time").yellow);
          return _watch();
        case 'RUNNING':
          console.error(("Watcher " + pid + " is running now").red);
          return callback();
      }
    });
  };

  exports.unwatch = function(options) {
    var pid, source, _ref1;
    if (options == null) {
      options = {};
    }
    source = _parseOptions(options).source;
    pid = (_ref1 = dump[source]) != null ? _ref1.pid : void 0;
    if (pid == null) {
      return console.error('The watcher is never runned!'.red);
    }
    return _checkWatcherStatus(pid, function(status) {
      switch (status) {
        case 'QUITED':
          console.warn('Watcher has already stopped'.yellow);
          break;
        case 'RUNNING':
          process.kill(pid, 'SIGTERM');
          console.log(("Watcher " + pid + " is stopped").green);
      }
      return _removeWatcher(source);
    });
  };

  exports.resurrect = function(callback) {
    var k, num, options, _results;
    if (callback == null) {
      callback = function() {};
    }
    num = Object.keys(dump).length;
    if (!(num > 0)) {
      return console.warn('No watcher exists'.yellow);
    }
    _results = [];
    for (k in dump) {
      options = dump[k];
      _results.push(exports.watch(options, function() {
        num -= 1;
        if (num === 0) {
          return callback();
        }
      }));
    }
    return _results;
  };

}).call(this);