#!/bin/bash
set -e
# postgis w/all exts
psql -v ON_ERROR_STOP=1 --username docker --dbname accessor <<-EOSQL
    CREATE EXTENSION postgis;
    CREATE EXTENSION postgis_raster;
    CREATE EXTENSION postgis_topology;
    CREATE EXTENSION postgis_sfcgal;
    CREATE EXTENSION fuzzystrmatchl
    CREATE EXTENSION address_standardizer;
    CREATE EXTENSION address_standardizer_data_us;
    CREATE EXTENSION postgis_tiger_geocoder;
EOSQL