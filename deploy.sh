#!/bin/bash

set -eu

if [ "$TRAVIS_BRANCH" = master ]; then
  git clone https://github.com/jiro4989/coc.git
  cd coc
  nimble install -Y
  coc -h
  cd ..
  nimble install -Y
  coc_radar scrape conf/page.csv | coc_radar generateJson
  git add docs/data
  git commit -m "by Travis CI (JOB $TRAVIS_JOB_NUMBER) [ci skip]"
  git push https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git HEAD:master
fi
