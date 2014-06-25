// Generated by CoffeeScript 1.7.1
(function() {
  var cli, commander, commands, pkg;

  commander = require('commander');

  pkg = require('../package.json');

  commands = require('./commands');

  cli = function() {
    commander.version(pkg.version).usage('[options] <command>').option('-o, --output <output>', 'set the output directory for compiled JavaScript').option('-s, --source <source>', 'set the source directory for CoffeeScript');
    commander.command('compile').description('compile to JavaScript and save as .js files').action(function() {
      return commands.compile(arguments[arguments.length - 1].parent);
    });
    commander.command('watch').description('watch for the file changes and compile to .js files').action(function() {
      return commands.watch(arguments[arguments.length - 1].parent, process.exit);
    });
    commander.command('unwatch').description('stop watch for the file changes').action(function() {
      return commands.unwatch(arguments[arguments.length - 1].parent);
    });
    commander.command('resurrect').description('resurrect previously watched processes').action(function() {
      return commands.resurrect(process.exit);
    });
    return commander.parse(process.argv);
  };

  module.exports = cli;

}).call(this);