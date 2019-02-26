#!/bin/bash -e

name="crystal_extractor"

docker rm $name | true

cd "$(dirname "$0")"
docker run \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  --name $name \
  --hostname="$name@docker" \
  -w /home/crystal/src/code \
  -it \
  -v `pwd`:/home/crystal/src/code dualsine/crystal_dev \
  /usr/bin/zsh
