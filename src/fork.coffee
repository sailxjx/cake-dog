path = require 'path'
colors = require 'colors'
coffeeCmd = require 'coffee-script/lib/coffee-script/command'
coffee = require 'coffee-script'
Notifier = require 'node-notifier'
notifier = new Notifier

fork = ->
  process.title = "cake-dog: #{path.basename(process.cwd())}"
  coffee.on 'failure', (err) -> notifier.notify
    title: 'Compile Error!'
    message: err.toString()
  coffeeCmd.run()

fork()
