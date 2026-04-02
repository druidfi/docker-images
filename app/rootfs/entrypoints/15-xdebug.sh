#!/bin/bash

XDEBUG_INI=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Detect Docker host: try DNS first, fall back to default gateway
if [ -z "$XDEBUG_CLIENT_HOST" ]; then
  if getent hosts host.docker.internal &>/dev/null; then
    XDEBUG_CLIENT_HOST="host.docker.internal"
  else
    XDEBUG_CLIENT_HOST=$(ip route show default 2>/dev/null | awk '/default/ {print $3; exit}')
    XDEBUG_CLIENT_HOST="${XDEBUG_CLIENT_HOST:-host.docker.internal}"
  fi
fi

if [ "$XDEBUG_ENABLE" = "true" ]; then
  echo "Start with Xdebug enabled (client: ${XDEBUG_CLIENT_HOST}). Remove XDEBUG_ENABLE=true ENV variable to disable it."
  if [ -f "$XDEBUG_INI" ]; then
    echo "Already enabled..."
  else
    doas mv "$XDEBUG_INI".disabled "$XDEBUG_INI"
    doas touch /tmp/xdebug.log && doas chmod 666 /tmp/xdebug.log
  fi
  doas sed -i "s/^xdebug.client_host=.*/xdebug.client_host=${XDEBUG_CLIENT_HOST}/" "$XDEBUG_INI"
else
  echo "Start with Xdebug disabled. Add XDEBUG_ENABLE=true ENV variable to enable it."
  if [ -f "$XDEBUG_INI" ]; then
    doas mv "$XDEBUG_INI" "$XDEBUG_INI".disabled
  else
    echo "Already disabled..."
  fi
fi
