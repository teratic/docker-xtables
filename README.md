# Docker xtables image

Docker image based on Ubuntu:10.04 with xtables-addons installed to build GEOIP tables.

A volume */xt_build* can be used to get the results.

```bash
$ docker build -t xtables .
$ mkdir -p build
$ docker run -v $(readlink -f build):/xt_build xtables
```