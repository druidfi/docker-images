#!/bin/sh

echo "Start up PHP-FPM..."

# -E option of sudo copies all env variables of current user to the root
sudo -E LD_PRELOAD=/usr/lib/preloadable_libiconv.so php-fpm7
