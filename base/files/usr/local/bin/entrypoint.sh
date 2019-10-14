#!/bin/sh

# This script will be the default ENTRYPOINT for all children docker images.
# It just sources all files within /entrypoints/* in an alphabetical order and then runs `exec` on the given parameter.

if [ -d /entrypoints ]; then
  for i in /entrypoints/*; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

exec "$@"
