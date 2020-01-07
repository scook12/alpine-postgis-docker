FROM postgres:11.4-alpine

LABEL MAINTAINER="Samuel Cook scook@esri.com"

ENV POSTGIS_VERSION="2.5.2"
ENV POSTGIS_SHA256="b6cb286c5016029d984f8c440947bf9178da72e1f6f840ed639270e1c451db5e"

RUN set -ex
RUN apk add --no-cache --virtual .fetch-deps ca-certificates openssl tar
RUN wget -O postgis.tar.gz "https://github.com/postgis/postgis/archive/${POSTGIS_VERSION}.tar.giz" \
    && echo "${POSTGIS_SHA256} *postgis.tar.gz" | sha256sum -c -

RUN mkdir -p /usr/src/postgis
RUN tar --extract --file postgis.tar.gz --directory /usr/src/postgis --strip-components 1 \
RUN rm -r postgis.tar.gz

RUN apk add --no-cache --virtual .build-deps autoconf automake g++ json-c-dev libtool libxml12-dev \
    make perl

RUN apk add --nocache --virtual .build-deps-edge gdal-dev geos-dev proj4-dev protobuf-c-dev \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main

RUN cd /usr/src/postgis && ./autogen.sh
RUN ./configure && make && make install
RUN apk add --no-cache --virtual .postgis-rundeps json-c 
RUN apk add --no-cache --virtual .postgis-rundeps-edge geos gdal proj4 protobuf-c \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main

RUN cd / && rm -rf /usr/src/postgis && apk del .fetch-deps .build-deps .build-deps-edge

COPY /scripts/add-user.sh /docker-entrypoint-initdb.d/add-user.sh
COPY /scripts/postgis.sh /docker-entrypoint-initdb.d/postgis.sh
COPY /scripts/update.sh /docker-entrypoint-initdb.d/update.sh