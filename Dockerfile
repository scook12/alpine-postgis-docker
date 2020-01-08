FROM postgres:11.4-alpine

LABEL MAINTAINER="Samuel Cook scook@esri.com"

ENV POSTGIS_VERSION="2.5.3"
ENV ALPINE_MIRROR "http://dl-cdn.alpinelinux.org/alpine"

RUN echo "${ALPINE_MIRROR}/edge/main" >> /etc/apk/repositories
RUN echo "${ALPINE_MIRROR}/edge/community" >> /etc/apk/repositories

RUN set -ex
RUN apk add --no-cache --virtual .fetch-deps ca-certificates openssl tar
RUN wget -O postgis.tar.gz "https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz"

RUN mkdir -p /usr/src/postgis
RUN tar --extract --file postgis.tar.gz --directory /usr/src/postgis --strip-components 1
RUN rm -r postgis.tar.gz

RUN apk add --no-cache --virtual .build-deps autoconf automake g++ json-c-dev libtool libxml2-dev make perl

RUN apk add --no-cache --virtual .build-deps-edge gdal-dev geos-dev proj-dev protobuf-c-dev

RUN cd /usr/src/postgis && ./autogen.sh && ./configure && make && make install
RUN apk add --no-cache --virtual .postgis-rundeps json-c 
RUN apk add --no-cache --virtual .postgis-rundeps-edge geos gdal proj protobuf-c 

RUN cd / && mkdir -p /docker-entrypoint-initdb.d
COPY /scripts/add-user.sh /docker-entrypoint-initdb.d/add-user.sh
COPY /scripts/postgis.sh /docker-entrypoint-initdb.d/postgis.sh
COPY /scripts/update-postgis.sh /docker-entrypoint-initdb.d/update.sh