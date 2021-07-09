ARG ALPINE_VERSION
ARG PHP_SHORT_VERSION

FROM alpine:3.13 as libiconv

RUN apk --update --no-cache add gnu-libiconv && \
    test -f /usr/lib/preloadable_libiconv.so || echo "preloadable_libiconv.so not found"

FROM druidfi/base:alpine-${ALPINE_VERSION} as build-php-73

ENV PHP_MAJOR_VERSION=7
ENV PHP_SHORT_VERSION=73

RUN sudo apk --update --no-cache add \
    php7 php7-curl php7-fileinfo php7-iconv php7-json php7-mbstring php7-opcache php7-openssl php7-phar \
    php7-session php7-zip \
    php7-pecl-apcu php7-pecl-redis php7-pecl-uploadprogress php7-pecl-xdebug

FROM druidfi/base:alpine-${ALPINE_VERSION} as build-php-74

ENV PHP_MAJOR_VERSION=7
ENV PHP_SHORT_VERSION=74

RUN sudo apk --update --no-cache add \
    php7 php7-curl php7-fileinfo php7-iconv php7-json php7-mbstring php7-opcache php7-openssl php7-phar \
    php7-session php7-zip \
    php7-pecl-apcu php7-pecl-redis php7-pecl-uploadprogress php7-pecl-xdebug

FROM druidfi/base:alpine-${ALPINE_VERSION} as build-php-80

ENV PHP_MAJOR_VERSION=8
ENV PHP_SHORT_VERSION=80

RUN sudo apk --update --no-cache add libzip && \
    sudo apk --update --no-cache add \
    php8 php8-curl php8-fileinfo php8-iconv php8-mbstring php8-opcache php8-openssl php8-phar \
    php8-session php8-zip && \
    sudo apk --update --no-cache add \
    php8-pecl-apcu php8-pecl-redis php8-pecl-uploadprogress php8-pecl-xdebug && \
    sudo ln -sfn /usr/bin/php8 /usr/bin/php

FROM build-php-${PHP_SHORT_VERSION} as final

ENV APP_ENV=prod \
    COMPOSER_HOME=/home/${DEFAULT_USER}/.composer \
    # Add /app/vendor/bin to PATH
    PATH="${PATH}:/home/${DEFAULT_USER}/.composer/vendor/bin:${APP_PATH}/vendor/bin"

# Install software
RUN sudo apk --update --no-cache add patch unzip && \
    sudo php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/local/bin/ --filename=composer && \
    #
    # Set permissions on Composer home directory
    #
    sudo mkdir -p ${COMPOSER_HOME} && \
    sudo chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${COMPOSER_HOME} && \
    #
    # Install Blackfire probe
    #
    architecture=$(case $(uname -m) in i386 | i686 | x86) echo "i386" ;; x86_64 | amd64) echo "amd64" ;; aarch64 | arm64 | armv8) echo "arm64" ;; *) echo "amd64" ;; esac) && \
    sudo curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/$architecture/${PHP_SHORT_VERSION} && \
    sudo mkdir -p /tmp/blackfire && \
    sudo tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire && \
    sudo mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so && \
    sudo rm -rf /tmp/blackfire

# Fix iconv library with Alpine by gnu-libiconv
COPY --from=libiconv /usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Copy configuration files and scripts
COPY files/entrypoints /entrypoints/
COPY files/etc/php/conf.d/* /etc/php${PHP_MAJOR_VERSION}/conf.d/

# Default command
CMD ["php", "-v"]
