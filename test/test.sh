#!/bin/bash
cd `dirname $0`
TEST_DIR=`pwd`
cakedog="${TEST_DIR}/../bin/cakedog"
dumpfile="~/.cakedog.json"

success() {
  echo -e "\033[32m====> ✔ $1\033[0m"
}

fail() {
  echo -e "\033[31m====> ✘ $1\033[0m"
  exit 1
}

should() {
  echo -e "\033[36m----> • $1\033[0m"
  $2
  [[ $? == 0 ]] || fail "$1"
  success "$1"
}

testcompile() {
  rm -rf lib/*
  $cakedog compile -s src -o lib
  [[ -f lib/test.js ]]
}

should 'compile source code from src to lib/' testcompile

testwatch() {
  rm -rf lib/*
  $cakedog watch -s src -o lib
  pid=`node ./readpid.js $(pwd)/src`
  sleep 0.2

  [[ $pid != 0 ]] && kill $pid && rm $dumpfile
  [[ $pid != 0 ]] && [[ -f lib/test.js ]] && sleep 0.2
}

should 'watch for the file change and compile' testwatch

testunwatch() {
  rm -rf lib/*

  $cakedog watch -s src -o lib
  sleep 0.2

  pid=`node ./readpid.js $(pwd)/src`
  $cakedog unwatch -s src
  sleep 0.2

  ps -p $pid
  [[ $? != 0 ]] && sleep 0.2
}

should 'kill the process and unwatch file changes' testunwatch

testunwatchbyname() {
  rm -rf lib/*

  $cakedog watch -s src -o lib
  sleep 0.2

  pid=`node ./readpid.js $(pwd)/src`
  $cakedog unwatch cake
  sleep 0.2

  ps -p $pid
  [[ $? != 0 ]] && sleep 0.2
}

should 'kill the process by path name and unwatch file changes' testunwatchbyname

testkill() {
  rm -rf lib/*

  $cakedog watch -s src -o lib
  sleep 0.2

  pid=`node ./readpid.js $(pwd)/src`
  $cakedog kill
  sleep 0.2

  ps -p $pid
  [[ $? != 0 ]] && sleep 0.2
}

should 'kill all cakedog processes' testkill

testresurrect() {
  $cakedog watch -s src -o lib
  sleep 0.2

  pid=`node ./readpid.js $(pwd)/src`
  kill $pid
  sleep 0.2

  $cakedog resurrect
  sleep 0.2

  pid1=`node ./readpid.js $(pwd)/src`
  [[ $pid1 != 0 ]] && ps -p $pid1
  alive=$?
  $cakedog unwatch -s "$(pwd)/src"
  sleep 0.2

  [[ alive != 0 ]] && [[ $pid != $pid1 ]] && sleep 0.2
}

should 'resurrect all watchers' testresurrect
