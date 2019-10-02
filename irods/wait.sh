#!/bin/bash

set -o nounset

wait_for_irods() {
    local max=20
    local attempt=0
    while [ $attempt -le $max ]; do
        iadmin lr archiveResc | grep -q S3_DEFAULT_HOSTNAME
        status=$?
        if [ $status -eq 0 ]; then
            break
        fi
        echo "Waiting for irods... ${attempt}/${max}"
        attempt=$(($attempt+1))
        sleep 1
        if [ $attempt -gt $max ]; then
            echo "Timeout!"
            exit 1
        fi
    done
}

wait_for_irods
