#!/bin/sh

docker build -t xtables .
mkdir -p build
docker run -v $(readlink -f build):/xt_build xtables


