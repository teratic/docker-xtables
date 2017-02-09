#!/bin/sh

GEOIP_DOWNLOAD_DIR=${GEOIP_DOWNLOAD_DIR-./download}
GEOIP_DB_DIR=${GEOIP_DB_DIR-./geoip}
GEOIP_XT_BUILD=${GEOIP_XT_BUILD-/usr/libexec/xtables-addons/xt_geoip_build}
GEOIP_VERBOSE=${GEOIP_VERBOSE-0}

URLS="http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip"
URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoIPv6.dat.gz"
URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoIPv6.csv.gz"
URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"
#URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoLiteCity_CSV/GeoLiteCity-latest.zip"
URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz"
#URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.csv.gz"
URLS="$URLS http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz"
#URLS="$URLS http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum2.zip"
URLS="$URLS http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNumv6.dat.gz"
#URLS="$URLS http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum2v6.zip"
URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz"
#URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoLite2-City-CSV.zip"
URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz"
URLS="$URLS http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip"

mkdir -p $GEOIP_DOWNLOAD_DIR
mkdir -p $GEOIP_DB_DIR

for url in $URLS
do
  FILENAME=$(basename "$url")
  [ $GEOIP_VERBOSE == 1 ] && echo "Getting "$FILENAME" ..."
  FILE_OLD_CHECKSUM=0
  TIME_STAMP="-S"
  if [ -f "$GEOIP_DOWNLOAD_DIR/$FILENAME" ]; then
    FILE_OLD_CHECKSUM=$(md5sum "$GEOIP_DOWNLOAD_DIR/$FILENAME" | cut -d ' ' -f 1)
    TIME_STAMP="-N"
    [ $GEOIP_VERBOSE == 1 ] && echo "File checksum is "$FILE_OLD_CHECKSUM""
  fi

  [ $GEOIP_VERBOSE == 1 ] && WGET_OPTS="--show-progress" || WGET_OPTS="-q"
  wget $TIME_STAMP $WGET_OPTS --tries=10 --wait=120 -P $GEOIP_DOWNLOAD_DIR $url
  # Basic check for first-run wget problems below - it won't catch
  # errors if a local copy of the file already exists.
  if [ ! -f "$GEOIP_DOWNLOAD_DIR/$FILENAME" ]; then
    echo "Unable to download "$FILENAME" from the location:"
    echo "$url"
    echo "and no local copy exits. Check URL and read comments within script file for notes on wget."
    exit -1
  # Copy downloaded file to where it will be used
  else
    FILE_NEW_CHECKSUM=$(md5sum "$GEOIP_DOWNLOAD_DIR/$FILENAME" | cut -d ' ' -f 1)
    # only extract file from GEOIP_DOWNLOAD_DIR to GEOIP_DB_DIR if it has changed
    if [ $FILE_OLD_CHECKSUM != $FILE_NEW_CHECKSUM ]; then
      DOWNLOADED="$DOWNLOADED $FILENAME"
      EXT=${FILENAME##*.}

      # Decompress file
      [ $GEOIP_VERBOSE == 1 ] && echo "Decompressing "$FILENAME" ..."
      case $EXT in
        "gz"|"GZ")
          gzip -dc $GEOIP_DOWNLOAD_DIR/$FILENAME > $GEOIP_DB_DIR/${FILENAME%.*}
          ;;
        "zip"|"ZIP")
          unzip -q -o $GEOIP_DOWNLOAD_DIR/$FILENAME -d $GEOIP_DB_DIR
          ;;
        *)
          echo "Error unsuported extension: $EXT"
          exit -1
          ;;
      esac
    fi
  fi
done

if [ ! -z "$DOWNLOADED" ]; then
    [ $GEOIP_VERBOSE == 1 ] && echo "Updated: $DOWNLOADED";
    $GEOIP_XT_BUILD -D$GEOIP_DB_DIR $GEOIP_DB_DIR/GeoIPCountryWhois.csv $GEOIP_DB_DIR/GeoIPv6.csv
fi
