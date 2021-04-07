#!/usr/bin/env bash

. /functions.sh

[ -z "$SERVER_ID" ] && echo "SERVER_ID must be defined" && exit 1

case "$MODE" in
  master)
    prepare_master
    ;;
  slave)
    prepare_slave
    ;;
  *)
    echo MODE is invalid or undefined
    exit 1
    ;;
esac

exec docker-entrypoint.sh "$@"
