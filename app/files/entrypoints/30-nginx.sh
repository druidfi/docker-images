#!/bin/bash

echo "Prepare Nginx conf..."

doas ep -v /etc/nginx/conf.d/default.conf
