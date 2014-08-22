commander = require 'commander'
pkg = require '../package.json'
commands = require './commands'

cli = ->
  commander.version pkg.version
    .usage '[options] <command>'
    .option '-o, --output <output>', 'set the output directory for compiled JavaScript'
    .option '-s, --source <source>', 'set the source directory for CoffeeScript'

  commander.command 'compile'
    .description 'compile to JavaScript and save as .js files'
    .action -> commands.compile arguments[arguments.length - 1].parent

  commander.command 'watch'
    .description 'watch for the file changes and compile to .js files'
    .action -> commands.watch arguments[arguments.length - 1].parent, process.exit

  commander.command 'unwatch'
    .description 'stop watch for the file changes'
    .action ->
      last = arguments.length - 1
      arguments[last] = arguments[last].parent
      commands.unwatch.apply commands, arguments

  commander.command 'kill'
    .description 'stop all watchers'
    .action -> commands.kill()

  commander.command 'resurrect'
    .description 'resurrect previously watched processes'
    .action -> commands.resurrect process.exit

  commander.parse process.argv

module.exports = cli
