#!/bin/bash

set -e
set -x

export AWS_ACCESS_KEY_ID=demo:demo
export AWS_SECRET_ACCESS_KEY=DEMO_PASS
export AWS_DEFAULT_REGION=us-east-1

USER=$(id -nu)

function test_file() {

    iput -R compResc foo.txt

    # the foo.txt should be shown both (one in cacheResc and one in archiveResc)
    [ $(ils -l | grep -c foo.txt) -eq 2 ] || (
        echo "Missing replica"
        exit 1
    )

    [ $(ils -l | grep foo.txt | grep -c cacheResc) -eq 1 ] || (
        echo "missing in archiveResc"
        exit 1
    )

    #
    [ $(ils -l | grep foo.txt | grep -c archiveResc) -eq 1 ] || (
        echo "missing in archiveResc"
        exit 1
    )

    #
    aws --endpoint-url http://172.24.0.100:5000 s3api head-object --bucket test --key irods/Vault/home/${USER}/foo.txt || (
        echo "File missing on S3"
        exit 1
    )

    irm foo.txt

    aws --endpoint-url http://172.24.0.100:5000 s3api head-object --bucket test --key irods/Vault/home/${USER}/foo.txt && (
        echo "File found on S3"
        exit 1
    )

    aws --endpoint-url http://172.24.0.100:5000 s3api head-object --bucket test --key irods/Vault/trash/home/${USER}/foo.txt || (
        echo "File missing on S3"
        exit 1
    )

    # empty trash
    irmtrash
}

cd $HOME

echo "Simple object"
# single object
cp /etc/magic foo.txt
test_file

echo "MPU object"
# dd if=/dev/zero of=foo.txt bs=1M count=128
# test_file

echo "OK"
