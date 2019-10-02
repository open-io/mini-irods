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

export AWS_ACCESS_KEY_ID=demo:demo
export AWS_SECRET_ACCESS_KEY=DEMO_PASS
export AWS_DEFAULT_REGION=us-east-1
aws --endpoint-url http://172.24.0.100:5000 s3api create-bucket --bucket test || (
    echo "Bucket creation has failed"
    exit 1
)

cat <<EOF >/s3.keypair
$AWS_ACCESS_KEY_ID
$AWS_SECRET_ACCESS_KEY
EOF

ARGS="S3_DEFAULT_HOSTNAME=172.24.0.100:5000;S3_AUTH_FILE=/s3.keypair;S3_RETRY_COUNT=1;S3_WAIT_TIME_SEC=5;S3_PROTO=HTTP"

# prepare requirements for S3 plugin
mkdir /cache
chown irods:irods /cache

iadmin mkresc compResc compound
iadmin mkresc cacheResc unixfilesystem localhost:/cache/iRods/
iadmin mkresc archiveResc s3 localhost:/test/irods/Vault "$ARGS"
iadmin addchildtoresc compResc cacheResc cache
iadmin addchildtoresc compResc archiveResc archive

tail -f /var/lib/irods/log/rodsLog*

exit 0
