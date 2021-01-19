#!/bin/sh

echo "Prepare PHP 99_custom.ini conf..."

sudo --preserve-env ep -v /etc/php$PHP_MAJOR_VERSION/conf.d/99_dynamic.ini.ep
sudo mv /etc/php$PHP_MAJOR_VERSION/conf.d/99_dynamic.ini.ep /etc/php$PHP_MAJOR_VERSION/conf.d/99_dynamic.ini
