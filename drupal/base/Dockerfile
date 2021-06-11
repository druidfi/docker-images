ARG BASE_PHP_IMAGE_NAME
ARG PHP_VERSION
ARG PHP_SHORT_VERSION

FROM ${BASE_PHP_IMAGE_NAME}:${PHP_VERSION}-fpm AS build

ENV DRUPAL_DB_NAME=drupal \
    DRUPAL_DB_USER=drupal \
    DRUPAL_DB_PASS=drupal \
    DRUPAL_DB_HOST=db \
    DRUPAL_DB_PORT=3306 \
    SSH_AUTH_SOCK=/tmp/ssh-agent

RUN sudo apk --update --no-cache add \
    #
    # Install ImageMagick
    #
    imagemagick \
    #
    # Install MySQL client
    #
    mysql-client \
    #
    # openssh and rsync are needed for using Drush aliases and connecting to them
    #
    openssh rsync && \
    #
    # Create some folders for Drush
    #
    mkdir -p /home/${DEFAULT_USER}/.drush /home/${DEFAULT_USER}/drush-backups/drupal

FROM build as build-php-73

RUN sudo apk --update --no-cache add \
    php7-bcmath php7-ctype php7-dom php7-exif php7-gd php7-intl php7-pdo php7-pdo_mysql php7-simplexml php7-sockets \
    php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zlib

FROM build as build-php-74

RUN sudo apk --update --no-cache add \
    php7-bcmath php7-ctype php7-dom php7-exif php7-gd php7-intl php7-pdo php7-pdo_mysql php7-simplexml php7-sockets \
    php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zlib

FROM build as build-php-80

RUN sudo apk --update --no-cache add \
    php8-bcmath php8-ctype php8-dom php8-exif php8-gd php8-intl php8-pdo php8-pdo_mysql php8-simplexml php8-sockets \
    php8-tokenizer php8-xml php8-xmlreader php8-xmlwriter

FROM build-php-${PHP_SHORT_VERSION} as final

# Copy configuration files and scripts
COPY files/ /

USER ${DEFAULT_USER}
