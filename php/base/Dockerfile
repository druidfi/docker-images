ARG ALPINE_VERSION
ARG PHP_SHORT_VERSION

FROM druidfi/base:alpine${ALPINE_VERSION} AS build

ENV APP_ENV=prod \
    COMPOSER_HOME=/home/${DEFAULT_USER}/.composer \
    # Add /app/vendor/bin to PATH
    PATH="/home/${DEFAULT_USER}/.composer/vendor/bin:${APP_PATH}/vendor/bin:${PATH}"

# Download mhsendmail binary
COPY binaries /usr/local/bin/mhsendmail

# Install software
RUN sudo apk --update --no-cache add patch unzip

FROM build as build-php-73

RUN sudo apk --update --no-cache add \
    php7 php7-curl php7-fileinfo php7-iconv php7-json php7-mbstring php7-opcache php7-openssl php7-phar \
    php7-session php7-zip \
    php7-pecl-xdebug php7-pecl-apcu

FROM build as build-php-74

RUN sudo apk --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community add \
    php7 php7-curl php7-fileinfo php7-iconv php7-json php7-mbstring php7-opcache php7-openssl php7-phar \
    php7-session php7-zip \
    php7-pecl-xdebug php7-pecl-apcu

FROM build-php-${PHP_SHORT_VERSION} as final

# Install software
RUN sudo php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --filename=composer && \
    #
    # Set permissions on Composer home directory
    #
    sudo chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${COMPOSER_HOME} && \
    #
    # Set permissions
    #
    sudo chmod +x /usr/local/bin/mhsendmail

# Fix work iconv library with Alpine
RUN sudo apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Copy configuration files and scripts
COPY files/ /

# Default command
CMD ["sudo", "php", "-v"]
