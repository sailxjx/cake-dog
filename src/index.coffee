{exec} = require('child_process')
colors = require('colors')
dogFile = "#{__dirname}/../bin/dog"

callback = (err, stdout, stderr) ->
  if err? or stderr.length > 0
    console.log stderr.toString().trim().red if stderr.length > 0
    console.log 'Message:'.grey
    console.log stdout.toString().trim().red
  else
    console.log stdout.toString().trim().green
  process.exit()

task 'compile', "once compile coffee scripts to javascript files", (options) ->
  exec("#{dogFile} compile", callback)

task 'compile:watch', 'real-time compile coffee scripts to javascript files', (options) ->
  exec("#{dogFile} compile_watch", {timeout: 100}, callback)

task 'compile:unwatch', 'stop compile coffee scripts to javascript files', (options) ->
  exec("#{dogFile} compile_unwatch", callback)