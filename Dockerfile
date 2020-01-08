FROM alpine:3.10

LABEL maintainer="Samuel Cook scook@esri.com"

ENV LANG en_US.utf8

RUN mkdir /docker-entrypoint-initdb.d
COPY ./scripts/postgis.sh /docker-entrypoint-initdb.d
COPY ./scripts/update-postgis.sh /docker-entrypoint-initdb.d

RUN set -ex
RUN mkdir -p "/var/lib/postgresql"
RUN chown -R postgres:postgres "/var/lib/postgresql"

RUN apk update && apk upgrade
RUN apk add --no-cache -U postgresql=11.6-r0
#RUN echo "installed"

ENTRYPOINT [ "docker-entrypoint.sh" ]
EXPOSE 5432
CMD ["postgres"]