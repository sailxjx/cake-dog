path = require 'path'
fs = require 'fs'
colors = require 'colors'
coffeeCmd = require 'coffee-script/lib/coffee-script/command'
coffee = require 'coffee-script'
Notifier = require 'node-notifier'
notifier = new Notifier

fork = ->
  src = process.argv[process.argv.length - 1]
  process.title = "cake-dog: #{src}"
  coffee.on 'failure', (err) -> notifier.notify
    title: 'Compile Error!'
    message: err.toString()
  stdout = fs.createWriteStream '/dev/null'
  process.__defineGetter__ 'stdout', -> stdout
  process.__defineGetter__ 'stderr', -> stdout
  coffeeCmd.run()

fork()
