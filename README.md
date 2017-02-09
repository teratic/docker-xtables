# Docker xtables image

Docker image based on alpine:edge with xtables-addons installed to build GEOIP tables.

A volume */xt_build* can be used to get the results.

```bash
$ docker build -t xtables .
$ mkdir -p build
$ docker run -v $(readlink -f build):/xt_build --user $(id -u):$(id -g) xtables
```

Or simply

```
$ ./run.sh
```
