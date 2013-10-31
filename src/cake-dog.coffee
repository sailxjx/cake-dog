path = require('path')
fs = require('fs')
coffeeCmd = require('coffee-script/lib/coffee-script/command')

exports.watch = watch = ->
  process.title = "cake-dog: #{path.basename(process.cwd())}"
  if process.argv[2] is 'quiet'
    stdout = fs.createWriteStream('/dev/null')
    process.__defineGetter__ 'stdout', -> stdout
    process.__defineGetter__ 'stderr', -> stdout
    process.argv.splice(2, 1)
  coffeeCmd.run()

watch()