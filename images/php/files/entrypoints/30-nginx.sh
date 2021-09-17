#!/bin/sh

echo "Prepare Nginx conf..."

ep -v /etc/nginx/conf.d/default.conf

echo "Start up Nginx..."

exec nginx -g 'daemon off;'
