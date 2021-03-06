path = require 'path'
fs = require 'fs'
mkdirp = require 'mkdirp'
colors = require 'colors'
coffeeCmd = require 'coffee-script/lib/coffee-script/command'
{exec, fork} = require 'child_process'

dumpfile = path.join process.env.HOME, '.cakedog.json'
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

_checkWatcherStatus = (pid, callback) ->
  exec "ps -p #{pid} | grep -v 'grep' | grep 'cake-dog'", (err, result) ->
    if err? or result?.trim().length < 1
      callback('QUITED')
    else
      callback('RUNNING')

_removeWatcher = (source) ->
  delete dump[source]
  fs.writeFileSync dumpfile, JSON.stringify(dump, null, 2)

_unwatch = (source) ->
  pid = dump[source].pid
  _checkWatcherStatus pid, (status) ->
    switch status
      when 'QUITED'
        console.warn 'Watcher has already stopped'.yellow
      when 'RUNNING'
        process.kill pid, 'SIGTERM'
        console.log "Watcher #{pid} is stopped".green
    _removeWatcher source

exports.compile = (options = {}) ->
  {output, source} = _parseOptions options
  [a1, a2] = process.argv
  process.argv = [a1, a2, '-o', output, '-c', source]
  coffeeCmd.run()
  console.log 'Compile finish'.green

exports.watch = (options = {}, callback = ->) ->
  {output, source} = _parseOptions options
  pid = dump[source]?.pid

  _watch = ->
    child = fork(path.resolve(__dirname, 'fork'), ['-w', '-o', output, '-c', source])
    dump[source] =
      pid: child.pid
      source: source
      output: output
    fs.writeFileSync dumpfile, JSON.stringify(dump, null, 2)
    console.log "Watching #{source}, pid: #{child.pid}".green
    return callback()

  return _watch() unless pid?

  _checkWatcherStatus pid, (status) ->
    switch status
      when 'QUITED'
        console.warn "Watcher #{pid} was exited unexpectedly last time".yellow
        _watch()
      when 'RUNNING'
        console.error "Watcher #{pid} is running now".red
        callback()

exports.unwatch = (name, options = {}) ->
  if toString.call(name) is '[object Object]'
    options = name
    name = null
  {source} = _parseOptions options
  sources = Object.keys(dump).filter (_source) ->
    if (source is _source or _source.indexOf(name) isnt -1) and dump[_source].pid?
      return true
    else
      return false
  return console.error 'The watcher is never runned!'.red unless sources.length?
  sources.forEach _unwatch

exports.kill = ->
  sources = Object.keys(dump)
  return console.error 'The watcher is never runned!'.red unless sources.length?
  sources.forEach _unwatch

exports.resurrect = (callback = ->) ->
  num = Object.keys(dump).length
  return console.warn 'No watcher exists'.yellow unless num > 0
  for k, options of dump
    exports.watch options, ->
      num -= 1
      return callback() if num is 0
