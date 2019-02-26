#!/bin/bash

echo "shell run"

./crystal_extractor \
    `pwd`/example_environment/entry.cr \
    `pwd`/example_environment/camera.cr \
    > out.log