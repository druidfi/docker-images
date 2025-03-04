#syntax=docker/dockerfile:1

ARG FRANKENPHP_VERSION=1.4.4-php8.4.4

# Base FrankenPHP image
FROM frankenphp_upstream AS frankenphp_base

ARG FRANKENPHP_VERSION

# defaults
ENV APP_ENV=dev XDEBUG_MODE=off FRANKENPHP_VERSION=$FRANKENPHP_VERSION

WORKDIR /app

VOLUME /app/var/

# persistent / runtime deps
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
	acl \
	file \
	gettext \
	git \
	&& rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	install-php-extensions \
		@composer \
		apcu \
		intl \
		opcache \
		zip \
	;

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"
ENV PHP_INI_SCAN_DIR=":$PHP_INI_DIR/app.conf.d"

COPY --link conf/php/ $PHP_INI_DIR/app.conf.d/
COPY --link conf/caddy/ /etc/caddy/
COPY --link --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

HEALTHCHECK --start-period=60s CMD curl -f http://localhost:2019/metrics || exit 1
CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile" ]
