#syntax=docker/dockerfile:1

ARG FRANKENPHP_VERSION=1.6.0-php8.4.7

# Base FrankenPHP image
FROM frankenphp_upstream AS frankenphp_base

# druidfi changes >>
ARG FRANKENPHP_VERSION

# defaults
ENV APP_ENV=dev
ENV XDEBUG_MODE=off
ENV FRANKENPHP_VERSION=$FRANKENPHP_VERSION
ENV FRANKENPHP_WORKER_CONFIG=watch
# << druidfi changes

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

# Transport to use by Mercure (default to Bolt)
ENV MERCURE_TRANSPORT_URL=bolt:///data/mercure.db

ENV PHP_INI_SCAN_DIR=":$PHP_INI_DIR/app.conf.d"

# druidfi changes >>
ENV PATH="${PATH}:/root/.composer/vendor/bin"
# << druidfi changes

COPY --link frankenphp/conf.d/ $PHP_INI_DIR/app.conf.d/
COPY --link --chmod=755 frankenphp/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY --link frankenphp/Caddyfile /etc/caddy/Caddyfile

ENTRYPOINT ["docker-entrypoint"]

HEALTHCHECK --start-period=60s CMD curl -f http://localhost:2019/metrics || exit 1
CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile" ]

# Handle dev and prod in project
