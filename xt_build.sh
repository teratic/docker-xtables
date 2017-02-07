#!/bin/sh

cd /xt_build

/usr/libexec/xtables-addons/xt_geoip_dl
/usr/libexec/xtables-addons/xt_geoip_build *.csv