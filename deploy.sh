#!/bin/bash

set -eu

if [ "$TRAVIS_BRANCH" = master ]; then
  git clone git@github.com:jiro4989/coc.git
  cd coc
  nimble install
  coc -h
  cd ..
  nim c -d:release update_json.nim
  ./update_json
  git add docs/js
  git commit -m "by Travis CI (JOB $TRAVIS_JOB_NUMBER)"
  git push origin master
fi
