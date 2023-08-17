#!/bin/bash

TEMPLATE=/usr/local/etc/php/conf.d/docker-php-ext-zzz-dynamic.ini.ep
TARGET=/usr/local/etc/php/conf.d/docker-php-ext-zzz-dynamic.ini

if [ -f "$TEMPLATE" ]; then
  echo "Prepare PHP docker-php-ext-zzz-dynamic.ini conf..."

  doas ep -v "$TEMPLATE"
  doas mv "$TEMPLATE" "$TARGET"
fi
