#!/bin/sh

TEMPLATE=/etc/php$PHP_MAJOR_VERSION/conf.d/99_dynamic.ini.ep
TARGET=/etc/php$PHP_MAJOR_VERSION/conf.d/99_dynamic.ini

if [ -f "$TEMPLATE" ]; then
  echo "Prepare PHP 99_custom.ini conf..."

  ep -v "$TEMPLATE"
  mv "$TEMPLATE" "$TARGET"
fi
