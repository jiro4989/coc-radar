#!/bin/bash

set -eu

if [ "$TRAVIS_BRANCH" = master ] && [ "$TRAVIS_PULL_REQUEST" = false ]; then
  coc_radar scrape conf/page.csv | coc_radar generateJson
  for status in ${PIPESTATUS[@]}; do
    if [ "$status" -ne 0 ]; then
      echo "Command failed." >&2
      exit 1
    fi
  done
  cp -r docs/data build/
fi
