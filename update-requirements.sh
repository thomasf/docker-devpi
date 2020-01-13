#!/bin/sh
set -e

poetry lock
poetry export -f requirements.txt --without-hashes -o requirements.txt
poetry export -f requirements.txt --without-hashes -o requirements-plugins.txt -E plugins
printf '\n\n'
grep devpi-server < requirements-plugins.txt
printf '\n\n'
grep devpi- < requirements-plugins.txt
