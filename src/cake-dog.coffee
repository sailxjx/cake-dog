path = require('path')
fs = require('fs')
coffeeCmd = require('coffee-script/lib/coffee-script/command')

exports.watch = watch = ->
  stdout = fs.createWriteStream('/dev/null')
  process.title = "cake-dog: #{path.basename(process.cwd())}"
  process.__defineGetter__ 'stdout', -> stdout
  process.__defineGetter__ 'stderr', -> stdout
  coffeeCmd.run()

watch()