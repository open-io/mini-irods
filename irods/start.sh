#!/bin/bash

set -e

while ! pg_isready -h sql -U postgres; do
    echo "waiting for DB"
    sleep 5
done

psql -h sql -U postgres --file=/create.sql

python /var/lib/irods/scripts/setup_irods.py --json_configuration_file=/config.json

sleep infinity

exit 0
