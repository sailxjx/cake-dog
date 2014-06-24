#!/usr/bin/env node
var path = require('path'),
    dumpfile;

try {
  dumpfile = require(path.join(process.env.HOME, '.cakedog.json'));
} catch (e) {
  dumpfile = {};
}

console.log(dumpfile[process.argv[2]] ? dumpfile[process.argv[2]].pid : '0');
