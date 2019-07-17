#!/bin/bash

set -eu

if [ "$TRAVIS_BRANCH" = master ] && [ "$TRAVIS_PULL_REQUEST" = false ]; then
  # JSON設定ファイルの書式チェック
  coc_radar validate

  # APIからのデータ取得
  coc_radar scrape

  cp -r docs/data build/
fi
