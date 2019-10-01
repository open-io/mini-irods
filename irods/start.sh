#!/bin/bash

set -e

while ! pg_isready -h sql -U postgres; do
    echo "waiting for DB"
    sleep 5
done

psql -h sql -U postgres --file=/create.sql

python /var/lib/irods/scripts/setup_irods.py --json_configuration_file=/config.json

/login-irods.sh rods rods

for U in alice bobby; do
    iadmin mkuser $U rodsuser
    iadmin moduser $U password password
    su - $U -c "/login-irods.sh $U password"
done

sleep infinity

exit 0
