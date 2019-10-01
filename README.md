# Mini iRods

Make it easy to  launch and test iRods+S3 integration

## How to build iRods image

    $ make build

## How to launch

    docker-compose up

## How start a shell

    # with iRods administrator account
    docker-compose exec irods /bin/bash

    # with enduser account
    docker-compose exec -u alice irods /bin/bash
