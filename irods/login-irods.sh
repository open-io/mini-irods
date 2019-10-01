#!/bin/bash

set -e


function irods_login() {
    local USER=${1}
    local PASSWORD=${2}
    mkdir -p ${HOME}/.irods
    cat <<EOF >${HOME}/.irods/irods_environment.json
{
    "irods_zone_name": "tempZone",
    "irods_host": "localhost",
    "irods_port": 1247,
    "irods_user_name": "${USER}"
}
EOF
    iinit ${PASSWORD}
}

irods_login $1 $2
