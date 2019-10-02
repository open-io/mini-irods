#!/bin/bash

set -o nounset

COMPOSE="docker-compose --file docker-compose.yml"

run_test_container() {
    $COMPOSE up -d
}

test_container() {
    echo "WAIT"
    $COMPOSE exec irods /wait.sh
    echo "TEST"
    $COMPOSE exec -u alice irods /test.sh
}

check_result() {
    local result="$1"
    if [[ "$result" != "0" ]]; then
        echo "FAIL: exit code: ${result}"
        cleanup
        exit $result
    fi
}

cleanup() {
    $COMPOSE rm --stop --force
}

run_test_container
test_container
check_result $?

cleanup
