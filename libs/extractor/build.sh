#!/bin/bash -e

# crystal build lib.cr --single-module -o lib.so

# gcc -fPIC -Wl,-rpath,$ORIGIN/. main.c ./lib.so -o main

cd "$(dirname $0)"

export LLVM_CONFIG=/usr/bin/llvm-config-5.0 

CRYSTAL_CACHE_DIR=./.build crystal build src/main.cr -o ./crystal_extractor

./run.sh