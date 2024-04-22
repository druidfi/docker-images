#!/bin/bash

EP="sudo --preserve-env ep"; [ "$APP_ENV" = "dev" ] && EP+=" -v"
TEMPLATE=/etc/php$PHP_INSTALL_VERSION/conf.d/99_dynamic.ini.ep
TARGET=/etc/php$PHP_INSTALL_VERSION/conf.d/99_dynamic.ini

if [ -f "$TEMPLATE" ]; then
  echo "- Prepare PHP 99_custom.ini conf..."

  $EP "$TEMPLATE"
  sudo mv "$TEMPLATE" "$TARGET"
fi

if [ $APP_ENV = 'prod' ]; then
  echo "- Enable 99_production.ini..."
  sudo mv \
    /etc/php$PHP_INSTALL_VERSION/conf.d/99_production.ini.dist \
    /etc/php$PHP_INSTALL_VERSION/conf.d/99_production.ini
fi
