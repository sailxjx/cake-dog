commander = require 'commander'
_ = require 'lodash'
pkg = require '../package.json'
commands = require './commands'

cli = ->
  commander.version pkg.version
    .usage '[options] <command>'
    .option '-o, --output <output>', 'set the output directory for compiled JavaScript'
    .option '-s, --source <source>', 'set the source directory for CoffeeScript'

  commander.command 'compile'
    .description 'compile to JavaScript and save as .js files'
    .action -> commands.compile _.last(arguments).parent

  commander.command 'watch'
    .description 'watch for the file changes and compile to .js files'
    .action -> commands.watch _.last(arguments).parent

  commander.command 'unwatch'
    .description 'stop watch for the file changes'
    .action -> commands.unwatch _.last(arguments).parent

  commander.command 'resurrect'
    .description 'resurrect previously watched processes'
    .action -> commands.unwatch _.last(arguments).parent

  commander.parse process.argv

module.exports = cli
