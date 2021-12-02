#!/bin/bash

TEMPLATE=/etc/php$PHP_INSTALL_VERSION/conf.d/99_dynamic.ini.ep
TARGET=/etc/php$PHP_INSTALL_VERSION/conf.d/99_dynamic.ini

if [ -f "$TEMPLATE" ]; then
  echo "Prepare PHP 99_custom.ini conf..."

  sudo --preserve-env ep -v "$TEMPLATE"
  sudo mv "$TEMPLATE" "$TARGET"
fi
