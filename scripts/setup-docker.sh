#!/bin/bash

# This scripts is for setting up rask image
# * Create rask image
# * Create master.key and credential.yml.enc
# * Migrate database for production
# * Compile assets

function usage() {
    cat <<_EOT_
Description:
    Setup Rask container

Note:
    This script is only for production environment.
    If you want to use development environment, build image with 'rask/Dockerfile'

Usage:
    setup-docker.sh <UserName>
    <UserName> : name of user that runs rask container.
_EOT_
}

function main() {
    cd $(dirname $0)
    cd ../

    if [ "$1" = "" ]; then
        usage
        exit 1
    fi

    if ! user_exists $1; then
        echo
        echo "Error:"
        echo "     Specified user does not exist"
        exit 1
    fi

    if ! [ -e .env ]; then
        echo
        echo "Error:"
        echo "    Not found: .env"
        echo "Help:"
        echo "    create .env from .env.sample"
        exit 1
    fi

    if ! [ -e db/development.sqlite3 ]; then
        echo
        echo "Information:"
        echo "    Not found: db/development.sqlite3"
        echo "    create empty db/development.sqlite3"
        touch db/development.sqlite3
    fi

    if ! [ -e db/production.sqlite3 ]; then
        echo
        echo "Information:"
        echo "    Not found: db/production.sqlite3"
        echo "    create empty db/production.sqlite3"
        touch db/production.sqlite3
    fi

    if ! [ -e config/master.key ]; then
            echo
            echo "Error:"
            echo "    'config/master.key' not found."
            echo "Help:"
            echo "    Bring master.key for current credentials.yml.enc"
            echo "    If you miss 'master.key', you can reset it by executing 'scripts/reset_master_key.sh'"
            exit 1
    fi

    echo
    echo "Creating Rask image"
    UID_SH=$(id -u $1)
    if ! docker buildx build \
        -t rask:$(git describe --tags --abbrev=0 || echo latest) \
        -f scripts/docker/Dockerfile_production \
        --secret id=master-key,src=$PWD/config/master.key \
        --build-arg UID=$UID_SH .
        then
        echo
        echo "Error:"
        echo "    Failed to build docker image"
        exit 1
    fi

    echo
    echo "Setting up in container"
    if ! docker run \
        -v $PWD/config:/home/rask/config \
        -v $PWD/db/production.sqlite3:/home/rask/db/production.sqlite3 \
        -v $PWD/db/development.sqlite3:/home/rask/db/development.sqlite3 \
        -it --rm --name rask-setup \
        rask scripts/docker/docker-setup.sh
        then
        echo
        echo "Error:"
        echo "    Failed to setup docker container"
        exit 1
    fi

    echo "Done."
}

function user_exists() {
    if id -u $1 > /dev/null; then
        return 0
    else
        return 1
    fi
}

main $1
