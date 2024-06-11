# syntax=docker/dockerfile:1.8

ARG ALPINE_VERSION
ARG PHP_SHORT_VERSION

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

# All images based on this one will have these ENV vars
ENV KIND=druid-docker-image \
    ALPINE_VERSION=${ALPINE_VERSION} \
    APP_PATH=/app \
    DEFAULT_USER=druid \
    DEFAULT_USER_UID=1000

# See https://docs.microsoft.com/en-us/azure/mysql/howto-configure-ssl
ADD --chmod=0644 https://cacerts.digicert.com/BaltimoreCyberTrustRoot.crt.pem /opt/ssl/
# See https://learn.microsoft.com/en-us/azure/postgresql/single-server/concepts-certificate-rotation#what-change-was-scheduled-to-be-performed-starting-december-2022-122022
ADD --chmod=0644 https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem /opt/ssl/
# https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-connect-tls-ssl
ADD --chmod=0644 https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem /opt/ssl/

RUN <<EOF
apk update && apk upgrade
apk --no-cache add bash curl git make msmtp nano neofetch ssmtp sudo tar tini
neofetch
addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID}
adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER}
echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:SETENV:ALL" > /etc/sudoers.d/${DEFAULT_USER}
chmod 0440 /etc/sudoers.d/${DEFAULT_USER}
chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}
install -o ${DEFAULT_USER} -g ${DEFAULT_USER} ${APP_PATH}
echo "Set disable_coredump false" > /etc/sudo.conf
EOF

COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} files/home/druid/ /home/druid
COPY files/usr/local/bin/ /usr/local/bin/
COPY --link --from=amazeeio/envplate:v1.0.3 /usr/local/bin/ep /usr/local/bin/ep
COPY files/entrypoints/00-umask.sh \
     files/entrypoints/15-xdebug.sh \
     files/entrypoints/19-php_ini.sh \
     files/entrypoints/40-ssmtp.sh /entrypoints/
COPY files/etc/msmtprc /etc/msmtprc
COPY files/etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf

SHELL ["/bin/bash", "-c"]
USER ${DEFAULT_USER}

WORKDIR ${APP_PATH}
ENTRYPOINT ["/sbin/tini", "--", "entrypoint"]

CMD ["tail", "-f", "/dev/null"]

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
# PHP 8.2
#
FROM base as build-php-82

ENV PHP_MAJOR_VERSION=8
ENV PHP_SHORT_VERSION=82
ENV PHP_INSTALL_VERSION=82

RUN sudo -s <<EOF
apk --no-cache add libcrypto3 libssl3 libzip \
  php82 php82-{curl,fileinfo,iconv,mbstring,opcache,openssl,phar,session,zip} \
  php82-pecl-{apcu,redis,uploadprogress,xdebug}
ln -sfn /usr/bin/php82 /usr/bin/php
EOF

RUN php -v

COPY files/etc/php/conf.d/* /etc/php82/conf.d/

#
# PHP 8.3
#
FROM base as build-php-83

ENV PHP_MAJOR_VERSION=8
ENV PHP_SHORT_VERSION=83
ENV PHP_INSTALL_VERSION=83

RUN sudo -s <<EOF
apk update
apk --no-cache add libcrypto3 libssl3 libzip \
  php83 php83-{curl,fileinfo,iconv,mbstring,opcache,openssl,phar,session,zip} \
  php83-pecl-{apcu,redis,uploadprogress,xdebug}
ln -sfn /usr/bin/php83 /usr/bin/php
EOF

RUN php -v

COPY files/etc/php/conf.d/* /etc/php83/conf.d/

#
# PHP
#
FROM build-php-${PHP_SHORT_VERSION} as final-php

# Fix iconv library with Alpine by gnu-libiconv
COPY --from=libiconv /usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

ENV APP_ENV=prod \
    COMPOSER_HOME=/home/${DEFAULT_USER}/.composer \
    COMPOSER_AUDIT_ABANDONED=report \
    COMPOSER_FUND=0 \
    PATH="${PATH}:/home/${DEFAULT_USER}/.composer/vendor/bin:${APP_PATH}/vendor/bin"

COPY --link --from=composer/composer:2-bin /composer /usr/bin/composer

RUN sudo -s <<EOF
apk --no-cache add patch unzip
install -o ${DEFAULT_USER} -g ${DEFAULT_USER} -d ${COMPOSER_HOME}
EOF

#
# PHP-FPM
#

FROM final-php as build-php-fpm-81

RUN sudo -s <<EOF
apk --no-cache add php81-fpm
ln -sfn /usr/sbin/php-fpm81 /usr/sbin/php-fpm
EOF

COPY files/etc/php/php-fpm.d/www.conf.ep /etc/php81/php-fpm.d/www.conf.ep

FROM final-php as build-php-fpm-82

RUN sudo -s <<EOF
apk --no-cache add php82-fpm
ln -sfn /usr/sbin/php-fpm82 /usr/sbin/php-fpm
EOF

COPY files/etc/php/php-fpm.d/www.conf.ep /etc/php82/php-fpm.d/www.conf.ep

FROM final-php as build-php-fpm-83

RUN sudo -s <<EOF
apk --no-cache add php83-fpm
ln -sfn /usr/sbin/php-fpm83 /usr/sbin/php-fpm
EOF

COPY files/etc/php/php-fpm.d/www.conf.ep /etc/php83/php-fpm.d/www.conf.ep

#
# Final PHP-FPM
#

FROM build-php-fpm-${PHP_SHORT_VERSION} as final-php-fpm

ENV PHP_SENDMAIL_PATH="/usr/bin/msmtp -t"

RUN sudo -s <<EOF
addgroup -g 82 -S www-data || echo "www-data group already exists"
adduser -u 82 -D -S -G www-data www-data
adduser ${DEFAULT_USER} www-data
EOF

CMD ["sudo", "-E", "LD_PRELOAD=/usr/lib/preloadable_libiconv.so", "php-fpm", "-F", "-R"]

#
# Drupal base
#

FROM final-php-fpm as drupal-php-81

RUN sudo -s <<EOF
apk --no-cache add mysql-client openssh rsync mariadb-connector-c \
    php81-{bcmath,ctype,dom,exif,gd,intl,pdo,pdo_mysql,simplexml,soap,sockets,sodium,tokenizer,xml,xmlreader,xmlwriter}
EOF

FROM final-php-fpm as drupal-php-82

RUN sudo -s <<EOF
apk --no-cache add mysql-client openssh rsync icu-libs mariadb-connector-c
apk --no-cache add \
    php82-{bcmath,ctype,dom,exif,gd,intl,pdo,pdo_mysql,simplexml,soap,sockets,sodium,tokenizer,xml,xmlreader,xmlwriter}
EOF

FROM final-php-fpm as drupal-php-83

RUN sudo -s <<EOF
apk --no-cache add mysql-client openssh rsync libavif icu-libs libsodium mariadb-connector-c
apk --no-cache add \
    php83-{bcmath,ctype,dom,exif,gd,intl,pdo,pdo_mysql,simplexml,soap,sockets,sodium,tokenizer,xml,xmlreader,xmlwriter}
EOF

#
# Drupal PHP
#

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
COPY drupal/set-permissions.sh /entrypoints/99-set-permissions.sh

#
# Drupal Web
#
FROM drupal-base as drupal-web

RUN sudo -s <<EOF
apk --no-cache add nginx
EOF

COPY files/entrypoints/20-php-fpm.sh files/entrypoints/30-nginx.sh /entrypoints/
COPY files/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY files/etc/nginx/fastcgi.conf /etc/nginx/fastcgi.conf
COPY files/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["sudo", "nginx"]
