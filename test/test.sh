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
  echo $pid
  # [[ -f lib/test.js ]]
}

should 'watch for the file change and compile' testwatch
