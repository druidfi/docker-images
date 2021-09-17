# syntax=docker/dockerfile:1.3-labs

ARG ALPINE_VERSION
ARG PHP_SHORT_VERSION

#
# libiconv
#
FROM alpine:3.13 as libiconv

RUN apk --update --no-cache add gnu-libiconv && test -f /usr/lib/preloadable_libiconv.so

#
# Base
#
FROM alpine:${ALPINE_VERSION} as base

LABEL org.opencontainers.image.authors="Druid".fi maintainer="Druid.fi"
LABEL org.opencontainers.image.source="https://github.com/druidfi/docker-images" repository="https://github.com/druidfi/docker-images"

#
# PHP 7
#
FROM base as build-php-7

ENV PHP_MAJOR_VERSION=7

RUN <<EOF
apk --update --no-cache add \
  php7 php7-curl php7-fileinfo php7-iconv php7-json php7-mbstring php7-opcache php7-openssl php7-phar php7-session php7-zip \
  php7-pecl-apcu php7-pecl-redis php7-pecl-uploadprogress php7-pecl-xdebug
EOF

FROM build-php-7 as build-php-73

ENV PHP_SHORT_VERSION=73

FROM build-php-7 as build-php-74

ENV PHP_SHORT_VERSION=74

#
# PHP 8
#
FROM base as build-php-80

ENV PHP_MAJOR_VERSION=8
ENV PHP_SHORT_VERSION=80

RUN <<EOF
apk --update --no-cache add libzip \
  php8 php8-curl php8-fileinfo php8-iconv php8-mbstring php8-opcache php8-openssl php8-phar php8-session php8-zip \
  php8-pecl-apcu php8-pecl-redis php8-pecl-uploadprogress php8-pecl-xdebug
ln -sfn /usr/bin/php8 /usr/bin/php
EOF

#
# PHP base
#
FROM build-php-${PHP_SHORT_VERSION} as base-php

COPY files/etc/php/conf.d/* /etc/php${PHP_MAJOR_VERSION}/conf.d/

# Fix iconv library with Alpine by gnu-libiconv
COPY --from=libiconv /usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Install software
RUN <<EOF
apk --update --no-cache add patch unzip
php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/ --filename=composer
EOF

#
# PHP
#
FROM base-php as final-php

#
# PHP-FPM
#
FROM base-php as final-php-fpm

RUN <<EOF
addgroup -g 82 -S www-data || echo "www-data group already exists"
adduser -u 82 -D -S -G www-data www-data
apk --update --no-cache add php${PHP_MAJOR_VERSION}-fpm
EOF

COPY files/etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf

CMD ["/usr/sbin/php-fpm7", "-F", "-R"]

#
# Drupal base
#

FROM final-php-fpm as base-drupal

ENV DRUPAL_DB_NAME=drupal \
    DRUPAL_DB_USER=drupal \
    DRUPAL_DB_PASS=drupal \
    DRUPAL_DB_HOST=db \
    DRUPAL_DB_PORT=3306 \
    SSH_AUTH_SOCK=/tmp/ssh-agent

FROM base-drupal as drupal-7

RUN <<EOF
apk --update --no-cache add \
  php7-bcmath php7-ctype php7-dom php7-exif php7-gd php7-intl php7-pdo php7-pdo_mysql php7-simplexml php7-sockets \
  php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zlib
EOF

#
# Drupal - PHP 7.3
#
FROM drupal-7 as drupal-73

#
# Drupal - PHP 7.4
#
FROM drupal-7 as drupal-74

#
# Drupal - PHP 8.0
#
FROM base-drupal as drupal-80

RUN <<EOF
apk --update --no-cache add \
  php8-bcmath php8-ctype php8-dom php8-exif php8-gd php8-intl php8-pdo php8-pdo_mysql php8-simplexml php8-sockets \
  php8-tokenizer php8-xml php8-xmlreader php8-xmlwriter
EOF

FROM drupal-${PHP_SHORT_VERSION} as drupal-final

#
# Drupal - PHP-FPM + Nginx
#

FROM drupal-final as drupal-web

# Install Nginx
RUN apk --update --no-cache add nginx

# Expose port 8080 for Nginx
EXPOSE 8080
