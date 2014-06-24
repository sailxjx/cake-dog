path = require 'path'
fs = require 'fs'
mkdirp = require 'mkdirp'
colors = require 'colors'
coffeeCmd = require 'coffee-script/lib/coffee-script/command'
{exec, fork} = require 'child_process'

dumpfile = path.join process.env.HOME, '~/.cakedog.json'
try
  dump = require dumpfile
catch e
  dump = {}

_parseOptions = (options = {}) ->
  {output, source} = options
  output or= process.cwd()
  source or= process.cwd()
  output = path.resolve output
  source = path.resolve source
  mkdirp.sync source unless fs.existsSync source
  options.source = source
  options.output = output
  return options

_checkWatcher = (pid, callback) ->
  return callback() unless pid?
  exec "ps -p #{pid} | grep -v 'grep' | grep 'cake-dog'", (err, result) ->
    if err? or result?.trim().length < 1
      console.error "Warn! Watcher #{pid} was exited unexpectedly last time".yellow
      callback()
    else
      console.error "Error! Watcher is running now".red
      callback(new Error('WATHER_RUNNING'))

exports.compile = (options = {}) ->
  {output, source} = _parseOptions options
  [a1, a2] = process.argv
  process.argv = [a1, a2, '-o', output, '-c', source]
  coffeeCmd.run()
  console.log 'Compile finish'.green

exports.watch = (options = {}) ->
  {output, source} = _parseOptions options
  pid = dump[source]?.pid
  _checkWatcher pid, (err) ->
    return if err?
    process.chdir source
    child = fork(path.resolve(__dirname, 'fork'), ['-w', '-o', output, '-c', source])
    dump[source] =
      pid: child.pid
      source: source
      output: output
    fs.writeFileSync dumpfile, JSON.stringify(dump, null, 2)
    console.log "Watching #{source}, pid: #{child.pid}".green
    process.exit()

exports.unwatch = (options = {}) ->

exports.resurrect = (options = {}) ->
