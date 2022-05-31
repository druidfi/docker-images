# syntax=docker/dockerfile:1.3-labs

ARG ALPINE_VERSION
ARG PHP_SHORT_VERSION

#
# Envplate
#
FROM alpine:${ALPINE_VERSION} AS envplate

ARG REPO=https://github.com/kreuzwerker/envplate/releases/download
ARG VERSION=1.0.2

WORKDIR /tmp
RUN apk add curl

RUN <<EOF
curl -LJ --silent ${REPO}/v${VERSION}/envplate_${VERSION}_Linux_arm64.tar.gz -o envplate_aarch64.tar.gz
curl -LJ --silent ${REPO}/v${VERSION}/envplate_${VERSION}_Linux_x86_64.tar.gz -o envplate_x86_64.tar.gz
tar -xf envplate_$(uname -m).tar.gz
chmod +x envplate
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

ARG ALPINE_VERSION

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
apk --no-cache add bash curl git make nano neofetch sudo tar tini
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
COPY --from=envplate /tmp/envplate /bin/ep
COPY files/entrypoints/00-umask.sh files/entrypoints/15-xdebug.sh files/entrypoints/19-php_ini.sh /entrypoints/

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
ENV PHP_INSTALL_VERSION=7

RUN sudo -s <<EOF
apk --no-cache add \
  php7 php7-{curl,fileinfo,iconv,json,mbstring,opcache,openssl,phar,session,zip} \
  php7-pecl-{apcu,redis,uploadprogress,xdebug}
EOF

COPY files/etc/php/conf.d/* /etc/php7/conf.d/
COPY files/entrypoints/16-blackfire.sh /entrypoints/

FROM build-php-7 as build-php-74

ENV PHP_SHORT_VERSION=74

#
# PHP 8.0
#
FROM base as build-php-80

ENV PHP_MAJOR_VERSION=8
ENV PHP_SHORT_VERSION=80
ENV PHP_INSTALL_VERSION=8

RUN sudo -s <<EOF
apk --no-cache add libzip \
  php8 php8-{curl,fileinfo,iconv,mbstring,opcache,openssl,phar,session,zip} \
  php8-pecl-{apcu,redis,uploadprogress,xdebug}
ln -sfn /usr/bin/php8 /usr/bin/php
EOF

COPY files/etc/php/conf.d/* /etc/php8/conf.d/
COPY files/entrypoints/16-blackfire.sh /entrypoints/

#
# PHP 8.1
#
FROM base as build-php-81

ENV PHP_MAJOR_VERSION=8
ENV PHP_SHORT_VERSION=81
ENV PHP_INSTALL_VERSION=81

RUN sudo -s <<EOF
apk --no-cache add libzip \
  php81 php81-{curl,fileinfo,iconv,mbstring,opcache,openssl,phar,session,zip} \
  php81-pecl-{apcu,redis,uploadprogress,xdebug}
ln -sfn /usr/bin/php81 /usr/bin/php
EOF

COPY files/etc/php/conf.d/* /etc/php81/conf.d/

#
# Blackfire
#
FROM build-php-${PHP_SHORT_VERSION} AS blackfire

ARG URL=https://blackfire.io/api/v1/releases/probe/php/alpine
ARG SO_PATH=/usr/lib/php${PHP_INSTALL_VERSION}/modules/blackfire.so

RUN sudo -s <<EOF
curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s ${URL}/$(uname -m)/${PHP_SHORT_VERSION}
mkdir -p /tmp/blackfire
tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire
mv /tmp/blackfire/blackfire-*.so ${SO_PATH}
rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz
EOF

RUN test -f ${SO_PATH}

#
# PHP
#
FROM build-php-${PHP_SHORT_VERSION} as final-php

# Fix iconv library with Alpine by gnu-libiconv
COPY --from=libiconv /usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Copy Blackfire
COPY --from=blackfire /usr/lib/php${PHP_INSTALL_VERSION}/modules/blackfire.so /usr/lib/php${PHP_INSTALL_VERSION}/modules/blackfire.so

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

FROM final-php as build-php-fpm-74

RUN sudo -s <<EOF
apk --no-cache add php7-fpm && ln -sfn /usr/sbin/php-fpm7 /usr/sbin/php-fpm
EOF

COPY files/etc/php/php-fpm.d/www.conf /etc/php7/php-fpm.d/www.conf

FROM final-php as build-php-fpm-80

RUN sudo -s <<EOF
apk --no-cache add php8-fpm && ln -sfn /usr/sbin/php-fpm8 /usr/sbin/php-fpm
EOF

COPY files/etc/php/php-fpm.d/www.conf /etc/php8/php-fpm.d/www.conf

FROM final-php as build-php-fpm-81

RUN sudo -s <<EOF
apk --no-cache add php81-fpm && ln -sfn /usr/sbin/php-fpm81 /usr/sbin/php-fpm
EOF

COPY files/etc/php/php-fpm.d/www.conf /etc/php81/php-fpm.d/www.conf

FROM build-php-fpm-${PHP_SHORT_VERSION} as final-php-fpm

RUN sudo -s <<EOF
addgroup -g 82 -S www-data || echo "www-data group already exists"
adduser -u 82 -D -S -G www-data www-data
adduser ${DEFAULT_USER} www-data
EOF

CMD ["sudo", "-E", "LD_PRELOAD=/usr/lib/preloadable_libiconv.so", "php-fpm", "-F", "-R"]

#
# Drupal base
#

FROM final-php-fpm as drupal-php-74

RUN sudo -s <<EOF
apk --no-cache add mysql-client openssh rsync \
    php7-{bcmath,ctype,dom,exif,gd,intl,pdo,pdo_mysql,simplexml,sockets,sodium,tokenizer,xml,xmlreader,xmlwriter,zlib}
EOF

FROM final-php-fpm as drupal-php-80

RUN sudo -s <<EOF
apk --no-cache add mysql-client openssh rsync \
    php8-{bcmath,ctype,dom,exif,gd,intl,pdo,pdo_mysql,simplexml,sockets,sodium,tokenizer,xml,xmlreader,xmlwriter}
EOF

FROM final-php-fpm as drupal-php-81

RUN sudo -s <<EOF
apk --no-cache -X https://dl-cdn.alpinelinux.org/alpine/edge/main add icu-libs
apk --no-cache -X https://dl-cdn.alpinelinux.org/alpine/edge/community add libavif
apk --no-cache -X https://dl-cdn.alpinelinux.org/alpine/edge/community add mysql-client openssh rsync \
    php81-{bcmath,ctype,dom,exif,gd,intl,pdo,pdo_mysql,simplexml,sockets,sodium,tokenizer,xml,xmlreader,xmlwriter}
EOF

FROM drupal-php-${PHP_SHORT_VERSION} as drupal-base

ENV DRUPAL_DB_NAME=drupal \
    DRUPAL_DB_USER=drupal \
    DRUPAL_DB_PASS=drupal \
    DRUPAL_DB_HOST=db \
    DRUPAL_DB_PORT=3306 \
    SSH_AUTH_SOCK=/tmp/ssh-agent

RUN sudo -s <<EOF
install -o ${DEFAULT_USER} -g ${DEFAULT_USER} -d /home/${DEFAULT_USER}/.drush /home/${DEFAULT_USER}/drush-backups/drupal
EOF

COPY files/entrypoints/10-ssh-agent.sh /entrypoints/

#
# Drupal Web
#
FROM drupal-base as drupal-web

RUN sudo -s <<EOF
apk --no-cache add nginx
EOF

COPY files/entrypoints/20-php-fpm.sh files/entrypoints/30-nginx.sh /entrypoints/
COPY files/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY files/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["sudo", "nginx"]

#HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8080/ping || exit 1
