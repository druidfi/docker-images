# syntax=docker/dockerfile:1.3-labs

ARG ALPINE_VERSION
ARG PHP_SHORT_VERSION

#
# Envplate
#
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

RUN apk --no-cache add gnu-libiconv && test -f /usr/lib/preloadable_libiconv.so

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
apk --no-cache add bash curl git make nano neofetch sudo tini
neofetch
addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID}
adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER}
echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:SETENV:ALL" > /etc/sudoers.d/${DEFAULT_USER}
chmod 0440 /etc/sudoers.d/${DEFAULT_USER}
chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}
install -o ${DEFAULT_USER} -g ${DEFAULT_USER} ${APP_PATH}
chmod 0644 /opt/ssl/BaltimoreCyberTrustRoot.crt.pem
echo "Set disable_coredump false" > /etc/sudo.conf
EOF

COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} files/home/druid/ /home/druid
COPY files/usr/local/bin/ /usr/local/bin/
COPY --from=envplate /go/bin/ep /bin/ep
COPY files/entrypoints/00-umask.sh /entrypoints/

SHELL ["/bin/bash", "-c"]
USER ${DEFAULT_USER}

WORKDIR ${APP_PATH}
ENTRYPOINT ["/sbin/tini", "--", "entrypoint"]

CMD ["tail", "-f", "/dev/null"]
#CMD ["sleep", "infinity"]

#
# PHP 7
#
FROM base as build-php-7

ENV PHP_MAJOR_VERSION=7

RUN sudo -s <<EOF
apk --no-cache add \
  php7 php7-{curl,fileinfo,iconv,json,mbstring,opcache,openssl,phar,session,zip} \
  php7-pecl-{apcu,redis,uploadprogress,xdebug}
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
apk --no-cache add libzip \
  php8 php8-{curl,fileinfo,iconv,mbstring,opcache,openssl,phar,session,zip} \
  php8-pecl-{apcu,redis,uploadprogress,xdebug}
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
# PHP
#
FROM build-php-${PHP_SHORT_VERSION} as final-php

COPY files/etc/php/conf.d/* /etc/php${PHP_MAJOR_VERSION}/conf.d/
COPY files/entrypoints/15-xdebug.sh files/entrypoints/16-blackfire.sh files/entrypoints/19-php_ini.sh /entrypoints/

# Fix iconv library with Alpine by gnu-libiconv
COPY --from=libiconv /usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Copy Blackfire
COPY --from=blackfire /usr/lib/php${PHP_MAJOR_VERSION}/modules/blackfire.so /usr/lib/php${PHP_MAJOR_VERSION}/modules/blackfire.so
COPY --from=blackfire /etc/php${PHP_MAJOR_VERSION}/conf.d/blackfire.ini /etc/php${PHP_MAJOR_VERSION}/conf.d/blackfire.ini

ENV APP_ENV=prod \
    COMPOSER_HOME=/home/${DEFAULT_USER}/.composer \
    PATH="${PATH}:/home/${DEFAULT_USER}/.composer/vendor/bin:${APP_PATH}/vendor/bin"

RUN sudo -s <<EOF
apk --no-cache add patch unzip
php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/ --filename=composer
install -o ${DEFAULT_USER} -g ${DEFAULT_USER} -d ${COMPOSER_HOME}
EOF

#
# PHP-FPM
#
FROM final-php as final-php-fpm

RUN sudo -s <<EOF
addgroup -g 82 -S www-data || echo "www-data group already exists"
adduser -u 82 -D -S -G www-data www-data
adduser ${DEFAULT_USER} www-data
apk --no-cache add php${PHP_MAJOR_VERSION}-fpm && ln -sfn /usr/sbin/php-fpm${PHP_MAJOR_VERSION} /usr/sbin/php-fpm
EOF

COPY files/etc/php/php-fpm.d/www.conf /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf

CMD ["sudo", "-E", "LD_PRELOAD=/usr/lib/preloadable_libiconv.so", "php-fpm", "-F", "-R"]

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
apk --no-cache add mysql-client openssh rsync \
    php${PHP_MAJOR_VERSION}-{bcmath,ctype,dom,exif,gd,intl,pdo,pdo_mysql,simplexml,sockets,tokenizer,xml,xmlreader,xmlwriter}
install -o ${DEFAULT_USER} -g ${DEFAULT_USER} -d /home/${DEFAULT_USER}/.drush /home/${DEFAULT_USER}/drush-backups/drupal
EOF

COPY files/entrypoints/10-ssh-agent.sh /entrypoints/

FROM base-drupal as drupal-7

RUN sudo apk --no-cache add php7-zlib

FROM drupal-7 as drupal-73
FROM drupal-7 as drupal-74
FROM base-drupal as drupal-80

#
# Drupal Web
#
FROM drupal-${PHP_SHORT_VERSION} as drupal-web

RUN sudo -s <<EOF
apk --no-cache add nginx || echo "nginx group already exists"
EOF

COPY files/entrypoints/20-php-fpm.sh files/entrypoints/30-nginx.sh /entrypoints/
COPY files/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY files/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["sudo", "nginx"]

#HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8080/ping || exit 1
