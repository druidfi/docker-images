#!/bin/bash

XDEBUG_INI=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

if [ "$XDEBUG_ENABLE" = "true" ]; then
  echo "Start with Xdebug enabled. Remove XDEBUG_ENABLE=true ENV variable to disable it."
  if [ -f "$XDEBUG_INI" ]; then
    echo "Already enabled..."
  else
    doas mv "$XDEBUG_INI".disabled "$XDEBUG_INI"
  fi
else
  echo "Start with Xdebug disabled. Add XDEBUG_ENABLE=true ENV variable to enable it."
  if [ -f "$XDEBUG_INI" ]; then
    doas mv "$XDEBUG_INI" "$XDEBUG_INI".disabled
  else
    echo "Already disabled..."
  fi
fi
