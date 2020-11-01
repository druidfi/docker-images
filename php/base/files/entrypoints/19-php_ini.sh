#!/bin/sh

echo "Prepare PHP 99_custom.ini conf..."

sudo --preserve-env ep -v /etc/php7/conf.d/99_custom.ini
