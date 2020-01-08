# About

Simple alpine postgis Dockerfile - lightweight and easy to use. Makes use of apk's packages unlike
most of the postgis dockerfiles.

## Setup

From source:
`git clone https://github.com/scook12/alpine-postgis-docker`
`docker build -t userName/repoName .`
`docker run --name some-alpine-postgis -e POSTGRES_PASSWORD=super_secret_key -d userName/repoName`

From dockerhub:
`docker pull cooksamuel/alpine-postgis`
`docker run --name some-alpine-postgis -e POSTGRES_PASSWORD=super_secret_key -d cooksamuel/alpine-postgis`

## Use

These two get you into a psql prompt:

`docker start some-alpine-postgis`
`docker run -it --link some-alpine-postgis:postgres --rm postgres \`
`sh -c "exec psql -h '$POSTGRES_PORT_5432_TCP_ADDR' -p '$POSTGRES_PORT_5432_TCP_PORT' -U postgres"`

Then run `dx` which should show plpgsql and postgis version 2.5.3 in a list of installed extensions.

## Contributing

Fork the repo, open an issue and submit a PR if you have something you'd like to contribute.