#!/bin/bash

TEMPLATE=/usr/local/etc/php/conf.d/docker-php-ext-zzz-dynamic.ini.ep
TARGET=/usr/local/etc/php/conf.d/docker-php-ext-zzz-dynamic.ini

if [ -f "$TEMPLATE" ]; then
  echo "Prepare PHP docker-php-ext-zzz-dynamic.ini conf..."

  doas ep -v "$TEMPLATE"
  doas mv "$TEMPLATE" "$TARGET"
fi

if [ "$APP_ENV" = "prod" ]; then
  echo "Enable production PHP ini..."
  doas cp -f /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
fi
