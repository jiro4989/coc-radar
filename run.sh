#!/bin/bash

set -eu

git clone https://github.com/jiro4989/coc
cd coc
nimble install -Y
cd ../

nim c -d:release update_json.nim
./update_json
