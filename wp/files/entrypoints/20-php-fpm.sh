#!/bin/sh

echo "Start up PHP-FPM..."

#
# NOTE! Don't run this with sudo, as then ENVs will not work
#
php-fpm7
