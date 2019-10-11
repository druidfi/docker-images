ARG ALPINE_VERSION
ARG PHP_VERSION

FROM druidfi/php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

LABEL maintainer="druid.fi"

#
# PHP ini files are in /usr/local/etc/php/conf.d
#

# Install PHP extensions needed by Drupal
RUN apk --update --no-cache add \
    php7 php7-fpm php7-pdo php7-pdo_mysql php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-session \
    php7-mbstring php7-gd php7-tokenizer php7-opcache php7-simplexml php7-xmlwriter