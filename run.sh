#!/bin/sh

docker build -t xtables .
mkdir -p build
docker run -v $(readlink -f build):/xt_build --user $(id -u):$(id -g) -e "GEOIP_VERBOSE=1" xtables


