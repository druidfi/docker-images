#!/bin/sh

echo "Prepare Nginx conf..."

sudo ep /etc/nginx/conf.d/default.conf

echo "Start up Nginx..."

sudo nginx -g 'daemon off;'
