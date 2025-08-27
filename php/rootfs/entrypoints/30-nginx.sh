#!/bin/bash

echo "- Prepare Nginx conf..."

EP="sudo --preserve-env ep"; [ "$APP_ENV" = "dev" ] && EP+=" -v"
$EP /etc/nginx/conf.d/default.conf
