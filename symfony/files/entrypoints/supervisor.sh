#!/bin/sh
set -e

echo "Start up supervisord..."

function start_supervisor() {
  exec supervisord --nodaemon --user=root --configuration /etc/supervisord.conf
}

start_supervisor &
