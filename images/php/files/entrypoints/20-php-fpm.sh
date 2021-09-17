#!/bin/sh

echo "Start up PHP-FPM..."

/usr/sbin/php-fpm"$PHP_MAJOR_VERSION" -F -R
