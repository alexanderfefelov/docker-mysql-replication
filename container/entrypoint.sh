#!/bin/bash

. /functions

[ -z "$SERVER_ID" ] && echo "SERVER_ID must be defined" && exit 1

case "$MODE" in
    master)
        init_master
        ;;
    slave)
        init_slave
        ;;
    *)
        echo MODE is invalid or undefined
        exit 1
        ;;
esac

exec docker-entrypoint.sh "$@"
