FROM ubuntu:14.04

MAINTAINER Marcos Lois Bermuderz <marcos.lois@teratic.com>

#
# /usr/lib/xtables-addons/xt_geoip_dl
# /usr/lib/xtables-addons/xt_geoip_build
#

RUN apt-get update
RUN apt-get install -y xtables-addons-common wget unzip libtext-csv-xs-perl

ADD xt_build.sh /xt_build.sh
RUN chmod 755 /xt_build.sh

RUN mkdir /xt_build
VOLUME /xt_build

CMD ["/xt_build.sh"]
