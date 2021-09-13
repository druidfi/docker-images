# syntax=docker/dockerfile:1.3-labs

ARG BASE_PHP_IMAGE_NAME
ARG PHP_VERSION
ARG PHP_SHORT_VERSION

FROM ${BASE_PHP_IMAGE_NAME}:${PHP_VERSION} AS build

ENV DRUPAL_DB_NAME=drupal \
    DRUPAL_DB_USER=drupal \
    DRUPAL_DB_PASS=drupal \
    DRUPAL_DB_HOST=db \
    DRUPAL_DB_PORT=3306 \
    SSH_AUTH_SOCK=/tmp/ssh-agent

# openssh and rsync are needed for using Drush aliases and connecting to them
# Create some folders for Drush
RUN sudo -s <<EOF
apk --update --no-cache add imagemagick mysql-client openssh rsync
mkdir -p /home/${DEFAULT_USER}/.drush /home/${DEFAULT_USER}/drush-backups/drupal
EOF

FROM build as build-php-7

RUN sudo -s <<EOF
apk --update --no-cache add \
  php7-bcmath php7-ctype php7-dom php7-exif php7-gd php7-intl php7-pdo php7-pdo_mysql php7-simplexml php7-sockets \
  php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zlib
EOF

FROM build-php-7 as build-php-73

FROM build-php-7 as build-php-74

FROM build as build-php-80

RUN sudo -s <<EOF
apk --update --no-cache add \
  php8-bcmath php8-ctype php8-dom php8-exif php8-gd php8-intl php8-pdo php8-pdo_mysql php8-simplexml php8-sockets \
  php8-tokenizer php8-xml php8-xmlreader php8-xmlwriter
EOF

FROM build-php-${PHP_SHORT_VERSION} as final

# Copy configuration files and scripts
COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} files/home/druid/.ssh/config /home/druid/.ssh/config
COPY files/entrypoints /entrypoints

USER ${DEFAULT_USER}
