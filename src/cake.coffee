path = require('path')
fs = require('fs')
{exec, fork} = require('child_process')
colors = require('colors')
pidFile = path.resolve('.compile.pid')

task 'compile', "once compile coffee scripts to javascript files", (options) ->
  child = fork(path.resolve(__dirname, 'cake-dog'), ['-o', 'lib', '-c', 'src'])
  child.on 'exit', (err) ->
    if err
      console.log 'Error! Compile error'.red
    else
      console.log 'Compile finish'.green

task 'compile:watch', 'real-time compile coffee scripts to javascript files', (options) ->
  _watch = ->
    child = fork(path.resolve(__dirname, 'cake-dog'), ['quiet', '-w', '-o', 'lib', '-c', 'src'])
    fs.writeFile pidFile, child.pid, (err, result) ->
      console.log "Start watching in process: #{child.pid}".green
      process.exit()

  fs.readFile pidFile, (err, result) ->
    return _watch() if err?.code is 'ENOENT' or result?.length < 1
    pid = result?.toString().trim()
    exec "ps -p #{pid} | grep -v 'grep' | grep 'cake-dog'", (err, result) ->
      if err? or result?.trim().length < 1
        console.log 'Warn! Process was exited unexpectedly last time'.yellow
        _watch()
      else
        console.log 'Error! Process is running now'.red

task 'compile:unwatch', 'stop compile coffee scripts to javascript files', (options) ->
  fs.readFile pidFile, (err, result) ->
    return console.log 'Error! Pid file not found'.red if err? or result?.length < 1
    pid = result.toString().trim()
    try
      process.kill(pid, 'SIGTERM')
      fs.unlink pidFile, (err) ->
        if err?
          console.log "Error! Can not remove pid file".red
          console.log "Message: #{err.toString()}".grey
        else
          console.log 'Watch process stoped'.green
    catch e
      console.log "Error! Can not stop process #{pid}".red
      console.log "Message: #{e}".grey
