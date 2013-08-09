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

task 'watch', 'real-time compile coffee scripts to javascript files', (options) ->
  exec("#{dogFile} watch", {timeout: 100}, callback)

task 'unwatch', 'stop compile coffee scripts to javascript files', (options) ->
  exec("#{dogFile} unwatch", callback)

task 'generate', "once compile coffee scripts to javascript files", (options) ->
  exec("#{dogFile} generate", callback)
