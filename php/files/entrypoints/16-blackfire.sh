#!/bin/sh

BLACKFIRE_INI=/etc/php$PHP_MAJOR_VERSION/conf.d/blackfire.ini

if [ "$BLACKFIRE_ENABLE" = "true" ]; then
  echo "Start with Blackfire probe enabled. Remove BLACKFIRE_ENABLE=true ENV variable to disable it."
  if [ -f "$BLACKFIRE_INI" ]; then
    echo "Already enabled..."
  else
    sudo mv "$BLACKFIRE_INI".disabled "$BLACKFIRE_INI"
  fi
else
  echo "Start with Blackfire probe disabled. Add BLACKFIRE_ENABLE=true ENV variable to enable it."
  if [ -f "$BLACKFIRE_INI" ]; then
    sudo mv "$BLACKFIRE_INI" "$BLACKFIRE_INI".disabled
  else
    echo "Already disabled..."
  fi
fi
