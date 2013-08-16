exec = require('child_process').exec
colors = require('colors')
dogFile = "#{__dirname}/../bin/dog"

callback = (err, stdout, stderr) ->
  if err?
    console.log err.toString().red
    console.log 'Message:'.grey
    console.log stdout.toString().red
  else
    console.log stdout.toString().green
  process.exit()

task 'compile', "once compile coffee scripts to javascript files", (options) ->
  exec("#{dogFile} compile", callback)

task 'compile:watch', 'real-time compile coffee scripts to javascript files', (options) ->
  exec("#{dogFile} compile_watch", {timeout: 100}, callback)

task 'compile:unwatch', 'stop compile coffee scripts to javascript files', (options) ->
  exec("#{dogFile} compile_unwatch", callback)