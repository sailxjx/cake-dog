path = require('path')
fs = require('fs')
coffeeCmd = require('coffee-script/lib/coffee-script/command')

exports.watch = watch = ->
  process.title = "cake-dog: #{path.basename(process.cwd())}"
  src = null

  for i, args of process.argv
    if args is '-c'
      src = process.argv[Number(i)+1]
      break

  fs.exists src, (exists) ->
    fs.mkdirSync src unless exists
    if process.argv[2] is 'quiet'
      stdout = fs.createWriteStream('/dev/null')
      process.__defineGetter__ 'stdout', -> stdout
      process.__defineGetter__ 'stderr', -> stdout
      process.argv.splice(2, 1)
    coffeeCmd.run()

watch()
