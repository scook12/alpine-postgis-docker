FROM alpine:3.10

LABEL maintainer="Samuel Cook scook@esri.com"

ENV LANG en_US.utf8

RUN mkdir /docker-entrypoint-initdb.d
COPY /scripts/postgis.sh /docker-entrypoint-initdb.d
COPY /scripts/update-postgis.sh /docker-entrypoint-initdb.d

RUN set -ex
# RUN mkdir -p "/var/lib/postgresql"
# RUN chown -R postgres:postgres "/var/lib/postgresql"

RUN apk update && apk upgrade
RUN apk add --no-cache -U postgresql=11.6-r0

RUN mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql && chmod 2777 /var/run/postgresql

ENV PGDATA /var/lib/postgresql/data
# this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)
RUN mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA"
VOLUME /var/lib/postgresql/data

COPY /scripts/docker-entrypoint.sh /usr/local/bin/
COPY /scripts/docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh
#RUN ln -s usr/local/bin/docker-entrypoint.sh /
ENTRYPOINT ["./docker-entrypoint.sh"]
EXPOSE 5432
CMD ["postgres"]