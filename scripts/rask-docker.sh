#!/bin/bash

#This script only works under below conditions
# 1. Docker is installed

# default value
DEFAULT_ATTACH_OPTION=it # {i|t|it|d}
DEFAULT_PORT=3000 # host port which container binds
DEFAULT_COMMAND="" # command which execute in container
                   # using default entrypoint of image, specify ""
DEFAULT_IMAGE_NAME=rask:$(git describe --tags --abbrev=0 || echo latest)
DEFAULT_ENVIRONMENT=production
# constant value
SCRIPT_NAME=rask-docker.sh

function print_usage(){
    cat <<_EOT_
$SCRIPT_NAME

Usage:
    $SCRIPT_NAME SubCommand

Description:
    start and stop $DEFAULT_IMAGE_NAME on container

SubCommands:
    start    start $DEFAULT_IMAGE_NAME container
             for more details, run '$SCRIPT_NAME start -h'
    stop     stop $DEFAULT_IMAGE_NAME container
             for more details, run '$SCRIPT_NAME stop -h'
    status   show conditions of $DEFAULT_IMAGE_NAME container
    restart  restart $DEFAULT_IMAGE_NAME container
             for more details, run '$SCRIPT_NAME restart -h'
    help     show this usage
_EOT_
}

function print_start_usage(){
    cat <<_EOT_
Usage:
    $SCRIPT_NAME start [OPTION] [COMMAND]

Description:
    run $DEFAULT_IMAGE_NAME container
    if COMMAND is specified, run COMMAND instead of dafault entrypoint

Options:
    -a         attach: connect tty to container
    -d         dettach: input and output is discarded
                        This option overrides -a option
    -p number  port: bind 'number' port (default $PORT)
    -i name    image: use 'name' image (default $DEFAULT_IMAGE_NAME)
    -e env     env: RAILS_ENV to run server (eg. prodcution, development) (default $DEFAULT_ENVIRONMENT)
    -h         help: show this usage
_EOT_
}

function print_stop_usage(){
    cat <<_EOT_
Usage:
    $SCRIPT_NAME stop [CONTAINER]

Description:
    stop $DEFAULT_IMAGE_NAME container
    if CONTAINER is specified, stop CONTAINER
    if CONTAINER is not specified, stop $DEFAULT_IMAGE_NAME-$DEFAULT_PORT if only $DEFAULT_IMAGE_NAME-$DEFAULT_PORT is running
_EOT_
}

function print_restart_usage(){
    cat <<_EOT_
Usage:
    $SCRIPT_NAME restart [CONTAINER]

Description:
    restart $DEFAULT_IMAGE_NAME container
    if CONTAINER is specified, restart CONTAINER
    if CONTAINER is not specified, restart $DEFAULT_IMAGE_NAME-$DEFAULT_PORT if only $DEFAULT_IMAGE_NAME-$DEFAULT_PORT is running
_EOT_
}

function main(){
    if ! user_belongs_dockergroup; then
        echo "$(whoami) must belong 'docker' group"
        exit 1
    fi

    cd "$(dirname "$0")" || exit 1
    cd ..

    subcommand=$1
    shift

    case $subcommand in
        start)
            start "$@"
            ;;
        stop)
            stop "$@"
            ;;
        status)
            status
            ;;
        restart)
            restart "$@"
            ;;
        help)
            print_usage
            ;;
        "")
            print_usage
            ;;
        *)
            echo "Invalid option: '$1'"
            exit 1
            ;;
    esac
    return 0
}

function start(){
    PORT=$DEFAULT_PORT
    COMMAND=$DEFAULT_COMMAND
    ATTACH_OPTION=$DEFAULT_ATTACH_OPTION
    IMAGE_NAME=$DEFAULT_IMAGE_NAME
    ENVIRONMENT=$DEFAULT_ENVIRONMENT
    set_start_options "$@"
    CONTAINER_NAME="${DEFAULT_IMAGE_NAME}-${PORT}"

    if container_is_running $CONTAINER_NAME; then
        echo "$CONTAINER_NAME is already runnning"
        exit 1
    fi

    if ! image_exists; then
        echo "docker image not found: $IMAGE_NAME"
        echo "build container image from Dockerfile"
        exit 1
    fi

    if (! istty) && [ $ATTACH_OPTION = it ]; then
        ATTACH_OPTION=i
    fi

    if port_is_used; then
        echo "Port $PORT is already used"
        exit 1
    fi

    echo "starting $CONTAINER_NAME"

    if container_is_stopped $CONTAINER_NAME; then
        docker start $CONTAINER_NAME > /dev/null
    else
        docker run \
            -$ATTACH_OPTION \
            -p $PORT:3000 \
            -v $PWD/log:/home/rask/log \
            -v $PWD/config:/home/rask/config \
            -v $PWD/db/production.sqlite3:/home/rask/db/production.sqlite3 \
            -v $PWD/db/development.sqlite3:/home/rask/db/development.sqlite3 \
            -v $PWD/.env:/home/rask/.env \
            -e RAILS_ENV=$ENVIRONMENT \
            --rm \
            --name $CONTAINER_NAME \
            $IMAGE_NAME $COMMAND
    fi
}

function set_start_options(){
    while getopts dhap:i:e: OPT; do
        case $OPT in
            a)
                ATTACH_OPTION=it
                ;;
            d)
                ATTACH_OPTION=d
                ;;
            h)
                print_start_usage
                exit 0
                ;;
            p)
                PORT=$OPTARG
                ;;
            i)
                IMAGE_NAME=$OPTARG
                ;;
            e)
                ENVIRONMENT=$OPTARG
                ;;
            *)
                echo "Invalid option: $OPT"
                exit 1
                ;;
        esac
    done
    COMMAND=${@:$OPTIND}
}

function stop(){
    set_stop_options "$@"
    if [ $# -eq 0 ]; then
        if only_default_running; then
            CONTAINER_NAME="${DEFAULT_IMAGE_NAME}-${DEFAULT_PORT}"
        else
            echo "${DEFAULT_IMAGE_NAME}-${DEFAULT_PORT} is not running or other $DEFAULT_IMAGE_NAME container is running."
            print_stop_usage
            exit 1
        fi
    fi

    if ! container_is_running $CONTAINER_NAME; then
        echo "$CONTAINER_NAME is not running"
        exit 1
    fi

    echo -n "trying to stop $CONTAINER_NAME... "
    docker stop $CONTAINER_NAME > /dev/null && \
        echo "done."
}

function set_stop_options(){
    while getopts h OPT; do
        case $OPT in
            h)
                print_stop_usage
                exit 0
                ;;
            *)
                echo "Invalid option: $OPT"
                exit 1
                ;;
        esac
    done
    CONTAINER_NAME=${@:$OPTIND}
}

function status(){
    if ! count_running_container $DEFAULT_IMAGE_NAME; then
        echo "Running container(s):"
        echo "NAMES       IMAGE"
        list_running_container $DEFAULT_IMAGE_NAME
    else
       echo "Container is not running"
    fi
}

function restart(){
    set_restart_options "$@"
    if [ $# -eq 0 ]; then
        if only_default_running; then
            CONTAINER_NAME="${DEFAULT_IMAGE_NAME}-${DEFAULT_PORT}"
        else
            echo "${DEFAULT_IMAGE_NAME}-${DEFAULT_PORT} is not running or other $DEFAULT_IMAGE_NAME container is running."
            print_restart_usage
            exit 1
        fi
    fi

    if ! container_is_running $CONTAINER_NAME; then
        echo "$CONTAINER_NAME is not running"
        exit 1
    fi

    PORT=$(docker inspect --format='{{range $conf := .NetworkSettings.Ports}}{{(index $conf 0).HostPort}} {{end}}' $CONTAINER_NAME)
    if [ $(docker inspect --format='{{.Config.AttachStdin}}' $CONTAINER_NAME) == "true" ]; then
        ATTACH_OPTION=a
    else
        ATTACH_OPTION=d
    fi

    stop $CONTAINER_NAME
    start -p $PORT -$ATTACH_OPTION
}

function set_restart_options(){
    while getopts h OPT; do
        case $OPT in
            h)
                print_restart_usage
                exit 0
                ;;
            *)
                echo "Invalid option: $OPT"
                exit 1
                ;;
        esac
    done
    CONTAINER_NAME=${@:$OPTIND}
}

function only_default_running(){
    count_running_container $DEFAULT_IMAGE_NAME
    if [ $? = 1 ]; then
        return $(container_is_running "$DEFAULT_IMAGE_NAME-$DEFAULT_PORT")
    else
        return 1
    fi
}

function user_belongs_dockergroup(){
    if [ $(groups | grep -c -e docker -e root) = 0 ]; then
        return 1
    else
        return 0
    fi
}

function list_running_container(){
    docker ps --format "table {{.Names}}\t{{.Image}}" | grep $1
}

function count_running_container(){
    return $(docker ps --format "table {{.Names}}" | grep -c $1)
}

function container_is_running(){
    if [ $(docker ps --format "table {{.Names}}" | grep -cx $1) = 0 ]; then
        return 1
    else
        return 0
    fi
}

function container_is_stopped(){
    if [ $(docker ps -f status=exited --format "table {{.Names}}" | grep -cx $1) = 0 ]; then
        return 1
    else
        return 0
    fi
}

function image_exists(){
    if [ $(docker images $IMAGE_NAME | wc -l) = 1 ]; then
        return 1
    else
        return 0
    fi
}

function istty(){
    if tty -s; then
        return 0
    else
        return 1
    fi
}

function port_is_used(){
    if [ $(lsof -i:$PORT | wc -l) != 0 ]; then
        return 0
    else
        return 1
    fi
}

main "$@"
