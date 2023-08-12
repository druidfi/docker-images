# syntax=docker/dockerfile:1.4

FROM php-fpm-base as symfony-fpm

WORKDIR /srv/app

# php extensions installer: https://github.com/mlocati/docker-php-extension-installer
COPY --from=mlocati/php-extension-installer --link /usr/bin/install-php-extensions /usr/local/bin/

# persistent / runtime deps
RUN apk add --no-cache \
		acl \
		fcgi \
		file \
		gettext \
		git \
        supervisor \
	;

RUN set -eux; \
    install-php-extensions \
    	intl \
    	zip \
    	apcu \
		opcache \
    ;

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY --link files/conf.d/app.ini $PHP_INI_DIR/conf.d/
COPY --link files/conf.d/app.prod.ini $PHP_INI_DIR/conf.d/

RUN test -f $PHP_INI_DIR/conf.d/app.ini

COPY --link files/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
RUN mkdir -p /var/run/php

COPY --link files/supervisor/messenger-worker.conf /etc/supervisor/conf.d/
RUN echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisord.conf
COPY --link files/entrypoints/supervisor.sh /entrypoints/

COPY --link files/docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck

HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

COPY --link files/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY --from=composer/composer:2-bin --link /composer /usr/bin/composer

# Build Caddy with the Mercure and Vulcain modules
FROM caddy:2.7-builder-alpine AS app_caddy_builder

RUN xcaddy build \
	--with github.com/dunglas/mercure \
	--with github.com/dunglas/mercure/caddy \
	--with github.com/dunglas/vulcain \
	--with github.com/dunglas/vulcain/caddy

# Caddy image
FROM caddy:2.7-alpine AS symfony-caddy-2

WORKDIR /srv/app

COPY --from=app_caddy_builder --link /usr/bin/caddy /usr/bin/caddy
COPY --link files/Caddyfile /etc/caddy/Caddyfile

# Symfony web image
FROM symfony-fpm as symfony-web

COPY --from=app_caddy_builder --link /usr/bin/caddy /usr/bin/caddy
COPY --link files/Caddyfile /etc/caddy/Caddyfile

EXPOSE 80
EXPOSE 443
EXPOSE 2019

COPY --link files/docker-entrypoint-web.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
