#!/bin/bash

set -eu

if [ "$TRAVIS_BRANCH" = master ] && [ "$TRAVIS_PULL_REQUEST" = false ]; then
  coc_radar scrape conf/page.csv | coc_radar generateJson
  git add docs/data
  git commit -m "by Travis CI (JOB $TRAVIS_JOB_NUMBER) [ci skip]"
  git push https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git HEAD:master
fi
