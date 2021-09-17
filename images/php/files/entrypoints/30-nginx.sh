#!/bin/sh

echo "Prepare Nginx conf..."

sudo --preserve-env ep -v /etc/nginx/conf.d/default.conf

echo "Start up Nginx..."

nginx -g 'daemon off;'
