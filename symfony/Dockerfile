# syntax=docker/dockerfile:1.3-labs

ARG PHP_VERSION=8.1
ARG CADDY_VERSION=2
ARG PHP_SHORT_VERSION=81

FROM php:${PHP_VERSION}-fpm-alpine as symfony-fpm-81

# persistent / runtime deps
RUN apk add --no-cache acl fcgi file gettext git

ARG APCU_VERSION=5.1.21

RUN <<EOF
apk add --no-cache --virtual .build-deps $PHPIZE_DEPS icu-dev libzip-dev zlib-dev postgresql-dev
docker-php-ext-configure zip
docker-php-ext-install -j$(nproc) pdo_mysql pdo_pgsql intl zip
pecl install apcu-${APCU_VERSION}
pecl clear-cache
docker-php-ext-enable apcu opcache
runDeps="$(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }')"
apk add --no-cache --virtual .phpexts-rundeps $runDeps
apk del .build-deps
EOF

COPY files/docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck

HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

RUN ln -s $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
COPY files/conf.d/symfony.prod.ini $PHP_INI_DIR/conf.d/symfony.ini

COPY files/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

COPY files/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

VOLUME /var/run/php

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

ENV PATH="${PATH}:/root/.composer/vendor/bin"

WORKDIR /srv/app

VOLUME /srv/app/var

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

FROM caddy:${CADDY_VERSION}-builder-alpine AS symfony-caddy-builder

RUN xcaddy build \
	--with github.com/dunglas/mercure \
	--with github.com/dunglas/mercure/caddy \
	--with github.com/dunglas/vulcain \
	--with github.com/dunglas/vulcain/caddy

FROM caddy:${CADDY_VERSION} AS symfony-caddy-2

WORKDIR /srv/app

COPY --from=dunglas/mercure:v0.11 /srv/public /srv/mercure-assets/
COPY --from=symfony-caddy-builder /usr/bin/caddy /usr/bin/caddy
COPY files/Caddyfile /etc/caddy/Caddyfile

FROM symfony-fpm-${PHP_SHORT_VERSION} as symfony-web-81

COPY --from=symfony-caddy-builder /usr/bin/caddy /usr/bin/caddy
COPY files/Caddyfile /etc/caddy/Caddyfile

EXPOSE 80
EXPOSE 443
EXPOSE 2019

COPY files/docker-entrypoint-web.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
