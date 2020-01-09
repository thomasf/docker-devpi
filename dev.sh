#!/bin/bash

doco() {
  docker-compose -f docker-compose.dev.yml "$@"
}

case ${1} in
  all)
    set -e
    # doco stop -t 0
    doco down -t 0 -v --remove-orphans
    doco rm -f -v
    doco build
    doco up
    ;;
  watch)
    watchexec -r -s SIGKILL -- ./dev.sh all
    ;;
esac
