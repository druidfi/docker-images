#!/bin/bash

echo "Prepare Nginx conf..."

sudo --preserve-env ep -v /etc/nginx/conf.d/default.conf
