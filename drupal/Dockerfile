ARG PHP_VERSION

FROM druidfi/php:${PHP_VERSION}-fpm

LABEL maintainer="druid.fi"

ENV SSH_AUTH_SOCK=/tmp/ssh-agent

# Install PHP extensions needed by Drupal
RUN apk --update --no-cache add \
    php7-ctype php7-dom php7-gd php7-intl php7-pdo php7-pdo_mysql php7-simplexml php7-tokenizer \
    php7-xml php7-xmlreader php7-xmlwriter php7-zlib \
    #
    #
    #
    mysql-client \
    #
    # openssh and rsync are needed for using Drush aliases and connecting to them
    #
    openssh rsync

# Copy configuration files and scripts
COPY files/ /
