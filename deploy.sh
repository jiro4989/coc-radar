#!/bin/bash

set -eu

if [ "$TRAVIS_BRANCH" = master ] && [ "$TRAVIS_PULL_REQUEST" = false ]; then
  coc_radar scrape conf/page.csv | coc_radar generateJson
  cp -r docs/data build/
fi
