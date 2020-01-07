#!/bin/bash
set -e
# postgis w/all exts
psql -v ON_ERROR_STOP=1 --username docker --dbname docker <<-EOSQL
    ALTER EXTENSION postgis UPDATE;
    ALTER EXTENSION postgis_raster UPDATE;
    ALTER EXTENSION postgis_topology UPDATE;
    ALTER EXTENSION postgis_sfcgal UPDATE;
    ALTER EXTENSION fuzzystrmatch UPDATE;
    ALTER EXTENSION address_standardizer UPDATE;
    ALTER EXTENSION address_standardizer_data_us UPDATE;
    ALTER EXTENSION postgis_tiger_geocoder UPDATE;
EOSQL