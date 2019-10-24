ARG ALPINE_VERSION
ARG COMPOSER_VERSION

FROM composer:${COMPOSER_VERSION} AS composer
FROM druidfi/base:alpine${ALPINE_VERSION} AS baseline

LABEL maintainer="druid.fi"

ARG USER=druid
ARG APP=/app
ARG UID=1000

ENV APP_ENV=prod \
    COMPOSER_HOME=/home/${USER}/.composer \
    # Add /app/vendor/bin to PATH
    PATH="${APP}/vendor/bin:${PATH}"

# Add Composer binary
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Install software
RUN apk --update --no-cache add \
    # PHP extensions
    php7 php7-curl php7-fpm php7-json php7-mbstring php7-opcache php7-openssl php7-phar php7-session php7-zip \
    # Xdebug
    php7-pecl-xdebug \
    # Patch for aplying patches in composer.json
    patch \
    # Unzip for unzipping possible zip packages in composer.json
    unzip && \
    # Install hirak/prestissimo Composer plugin
    composer global require hirak/prestissimo

# Copy configuration files and scripts
COPY files/ /

# Set directories and permissions
RUN chown -R ${USER}:${USER} ${COMPOSER_HOME} && \
    chmod -R g+rwX ${COMPOSER_HOME}

CMD ["/usr/sbin/php-fpm7", "-F", "-R"]
