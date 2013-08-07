exec = require('child_process').exec
spawn = require('child_process').spawn
colors = require('colors')
dogFile = './bin/dog'

callback = (err, stdout, stderr) ->
  if err?
    console.log err.toString().red
    console.log 'Message:'.grey
    console.log stdout.toString().red
  else
    console.log stdout.toString().green
  process.exit()

task 'watch', 'real-time compile coffee scripts to javascript files', (options) ->
  watch = exec("#{dogFile} watch", {timeout: 100}, callback)

task 'stop', 'stop compile coffee scripts to javascript files', (options) ->
  exec("#{dogFile} stop", callback)

task 'generate', "once compile coffee scripts to javascript files", (options) ->
  exec("#{dogFile} generate", callback)