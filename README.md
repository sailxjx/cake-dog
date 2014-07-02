Cake Dog
---
A loyal friend help for watching your CoffeeScript files

[![build status](https://api.travis-ci.org/sailxjx/cake-dog.png)](https://travis-ci.org/sailxjx/cake-dog)

## Install
```
[sudo] npm install -g cake-dog
```

## Usage

### Cli mode
You can use `cakedog` as a command-line tool
```
$ cakedog --help

  Usage: cakedog [options] <command>

  Commands:

    compile                compile to JavaScript and save as .js files
    watch                  watch for the file changes and compile to .js files
    unwatch                stop watch for the file changes
    resurrect              resurrect previously watched processes

  Options:

    -h, --help             output usage information
    -V, --version          output the version number
    -o, --output <output>  set the output directory for compiled JavaScript
    -s, --source <source>  set the source directory for CoffeeScript
```

### In Cakefile
You can prepend one line in your [`Cakefile`](http://coffeescript.org/documentation/docs/cake.html)

```
require("cake-dog")(options)
```

Now use `cake` command to see new tasks, these cake tasks will compile the source code from 'source' to 'output'

The default options is {source: 'src', output: 'lib'}

```
$ cake
Cakefile defines the following tasks:

cake compile      # once compile coffee scripts to javascript files
cake watch        # real-time compile coffee scripts to javascript files
cake unwatch      # stop compile coffee scripts to javascript files
```

## Uninstall

```
[sudo] npm rm -g cake-dog
```

And don't forget to remove the `require("cake-dog")` in your Cakefile (if you have done this).

Done!

## ChangeLog
### v0.4.1
* support options in Cakefile

### v0.4.0
* install cakedog as a global package and run in cli mode
* auto save the latest watch directories, and resurrect after reboot
* add options to watch directories

## Known Issues
* `Error: watch EMFILE` when use `cake compile:watch`
  This is caused by the limit of the use of system-wide resources in *nix system, you can increase the limitation by `ulimit -n XXXX` and this message will not show again, the `XXXX` is the number of limitation, set it greater than your watched file number.

## LICENSE

Copyright © 2013 Tristan Xu, http://sailxjx.github.io <sailxjx@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
