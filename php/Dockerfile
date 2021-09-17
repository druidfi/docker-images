# syntax=docker/dockerfile:1.3-labs

ARG ALPINE_VERSION
ARG PHP_SHORT_VERSION

FROM golang:alpine3.14 AS envplate

RUN <<EOF
GIT_TAG=github.com/kreuzwerker/envplate@1.0.0-RC1 GIT_COMMIT=977cb694fd31dd89e9326fe4c85572a147011c8f;
go get -ldflags "-X=main.build=$GIT_COMMIT -X=main.version=$GIT_TAG" github.com/kreuzwerker/envplate@$GIT_COMMIT
cd /go/pkg/mod/github.com/kreuzwerker/envplate*
go mod init github.com/kreuzwerker/envplate
go install -mod=mod ./bin/ep.go
EOF

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

# All images based on this one will have these ENV vars
ENV KIND=druid-docker-image \
    ALPINE_VERSION=${ALPINE_VERSION} \
    APP_PATH=/app \
    DEFAULT_USER=druid \
    DEFAULT_USER_UID=1000

# See https://docs.microsoft.com/en-us/azure/mysql/howto-configure-ssl
ADD https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt.pem /opt/ssl/

RUN <<EOF
apk update && apk upgrade
apk --update --no-cache add bash curl git make nano neofetch sudo tini
neofetch
addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID}
adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER}
echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:SETENV:ALL" > /etc/sudoers.d/${DEFAULT_USER}
chmod 0440 /etc/sudoers.d/${DEFAULT_USER}
chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}
mkdir -p ${APP_PATH}
chown ${DEFAULT_USER}:${DEFAULT_USER} ${APP_PATH}
chmod 0644 /opt/ssl/BaltimoreCyberTrustRoot.crt.pem
EOF

COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} files/home/druid/ /home/druid
COPY files/usr/local/bin/ /usr/local/bin/
COPY --from=envplate /go/bin/ep /bin/ep
COPY files/entrypoints/00-umask.sh /entrypoints/

USER ${DEFAULT_USER}

WORKDIR ${APP_PATH}
ENTRYPOINT ["/sbin/tini", "--", "entrypoint"]

#
# PHP 7
#
FROM base as build-php-7

ENV PHP_MAJOR_VERSION=7

RUN sudo -s <<EOF
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

RUN sudo -s <<EOF
apk --update --no-cache add libzip \
  php8 php8-curl php8-fileinfo php8-iconv php8-mbstring php8-opcache php8-openssl php8-phar php8-session php8-zip \
  php8-pecl-apcu php8-pecl-redis php8-pecl-uploadprogress php8-pecl-xdebug
ln -sfn /usr/bin/php8 /usr/bin/php
EOF

#
# Blackfire
#
FROM build-php-${PHP_SHORT_VERSION} AS blackfire

RUN sudo -s <<EOF
curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/$(uname -m)/${PHP_SHORT_VERSION}
mkdir -p /tmp/blackfire
tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire
mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so
printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8307\n" > /etc/php${PHP_MAJOR_VERSION}/conf.d/blackfire.ini
rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz
test -f $(php -r "echo ini_get ('extension_dir');")/blackfire.so
test -f /etc/php${PHP_MAJOR_VERSION}/conf.d/blackfire.ini
EOF

#
# PHP base
#
FROM build-php-${PHP_SHORT_VERSION} as base-php

COPY files/etc/php/conf.d/* /etc/php${PHP_MAJOR_VERSION}/conf.d/
COPY files/entrypoints/15-xdebug.sh /entrypoints/
COPY files/entrypoints/16-blackfire.sh /entrypoints/
COPY files/entrypoints/19-php_ini.sh /entrypoints/

# Fix iconv library with Alpine by gnu-libiconv
COPY --from=libiconv /usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Copy Blackfire
COPY --from=blackfire /usr/lib/php${PHP_MAJOR_VERSION}/modules/blackfire.so /usr/lib/php${PHP_MAJOR_VERSION}/modules/blackfire.so
COPY --from=blackfire /etc/php${PHP_MAJOR_VERSION}/conf.d/blackfire.ini /etc/php${PHP_MAJOR_VERSION}/conf.d/blackfire.ini

ENV APP_ENV=prod \
    COMPOSER_HOME=/home/${DEFAULT_USER}/.composer \
    # Add /app/vendor/bin to PATH
    PATH="${PATH}:/home/${DEFAULT_USER}/.composer/vendor/bin:${APP_PATH}/vendor/bin"

RUN sudo -s <<EOF
apk --update --no-cache add patch unzip
php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/ --filename=composer
mkdir -p ${COMPOSER_HOME}
chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${COMPOSER_HOME}
EOF

#
# PHP
#
FROM base-php as final-php

#
# PHP-FPM
#
FROM base-php as final-php-fpm

RUN sudo -s <<EOF
addgroup -g 82 -S www-data || echo "www-data group already exists"
adduser -u 82 -D -S -G www-data www-data
adduser ${DEFAULT_USER} www-data
apk --update --no-cache add php${PHP_MAJOR_VERSION}-fpm
EOF

COPY files/etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf
COPY files/entrypoints/20-php-fpm.sh /entrypoints/

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

# openssh and rsync are needed for using Drush aliases and connecting to them
# Create some folders for Drush
RUN sudo -s <<EOF
apk --update --no-cache add imagemagick mysql-client openssh rsync
mkdir -p /home/${DEFAULT_USER}/.drush /home/${DEFAULT_USER}/drush-backups/drupal
EOF

COPY files/entrypoints/10-ssh-agent.sh /entrypoints/

FROM base-drupal as drupal-7

RUN sudo -s <<EOF
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

RUN sudo -s <<EOF
apk --update --no-cache add \
  php8-bcmath php8-ctype php8-dom php8-exif php8-gd php8-intl php8-pdo php8-pdo_mysql php8-simplexml php8-sockets \
  php8-tokenizer php8-xml php8-xmlreader php8-xmlwriter
EOF

FROM drupal-${PHP_SHORT_VERSION} as drupal-final

#
# Drupal Web - PHP-FPM + Nginx
#

FROM drupal-final as drupal-web

RUN sudo -s <<EOF
apk --update --no-cache add nginx
EOF

COPY files/entrypoints/30-nginx.sh /entrypoints/
COPY files/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY files/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
