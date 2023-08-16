#!/bin/bash

TEMPLATE=/usr/local/etc/php/conf.d/docker-php-ext-zzz-dynamic.ini.ep
TARGET=/usr/local/etc/php/conf.d/docker-php-ext-zzz-dynamic.ini

if [ -f "$TEMPLATE" ]; then
  echo "Prepare PHP 99_custom.ini conf..."

  sudo --preserve-env ep -v "$TEMPLATE"
  sudo mv "$TEMPLATE" "$TARGET"
fi
