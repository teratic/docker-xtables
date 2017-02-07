FROM alpine:edge

MAINTAINER Marcos Lois Bermuderz <marcos.lois@teratic.com>

#
# /usr/lib/xtables-addons/xt_geoip_dl
# /usr/lib/xtables-addons/xt_geoip_build
#

RUN apk add --no-cache --update xtables-addons perl perl-text-csv_xs

COPY xt_build.sh /
RUN set -ex \
    && chmod 755 /xt_build.sh \
    && mkdir /xt_build \
    && chmod 777 /xt_build

VOLUME /xt_build

CMD ["/xt_build.sh"]
