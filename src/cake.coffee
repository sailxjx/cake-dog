path = require 'path'
commands = require './commands'

_commonOptions =
  output: path.resolve 'lib'
  source: path.resolve 'src'

task 'compile', "once compile coffee scripts to javascript files", (options) ->
  commands.compile _commonOptions

task 'compile:watch', 'real-time compile coffee scripts to javascript files', (options) ->
  commands.watch _commonOptions

task 'compile:unwatch', 'stop compile coffee scripts to javascript files', (options) ->
  commands.unwatch _commonOptions
