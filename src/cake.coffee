path = require 'path'
commands = require './commands'

cakedog = (options = {}) ->
  {output, source} = options
  _options =
    output: path.resolve output or 'lib'
    source: path.resolve source or 'src'

  task 'compile', "once compile coffee scripts to javascript files", (options) ->
    commands.compile _options

  task 'watch', 'real-time compile coffee scripts to javascript files', (options) ->
    commands.watch _options, process.exit

  task 'unwatch', 'stop compile coffee scripts to javascript files', (options) ->
    commands.unwatch _options

module.exports = cakedog
