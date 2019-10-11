ARG ALPINE_VERSION
ARG COMPOSER_VERSION
ARG PHP_VERSION

FROM composer:${COMPOSER_VERSION} AS composer
FROM druidfi/base:alpine${ALPINE_VERSION}

LABEL maintainer="druid.fi"

ARG USER=druid
ARG APP=/app
ARG UID=1000

ENV COMPOSER_HOME=/home/${USER}/.composer

# Add Composer binary
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Install software
RUN apk --update --no-cache add \
    php7 php7-curl php7-fpm php7-json php7-mbstring php7-opcache php7-openssl php7-phar php7-session

# Install hirak/prestissimo Composer plugin
RUN composer global require hirak/prestissimo

# Set directories and permissions
RUN chown -R ${USER}:${USER} ${COMPOSER_HOME} && \
    chmod -R g+rwX ${COMPOSER_HOME}
