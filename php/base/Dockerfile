ARG PHP_SHORT_VERSION

FROM druidfi/base:alpine3.12.3 as build-php-73

ENV PHP_MAJOR_VERSION=7
ENV PHP_SHORT_VERSION=73

RUN sudo apk --update --no-cache add \
    php7 php7-curl php7-fileinfo php7-iconv php7-json php7-mbstring php7-opcache php7-openssl php7-phar \
    php7-session php7-zip \
    php7-pecl-apcu php7-pecl-uploadprogress php7-pecl-xdebug

FROM druidfi/base:alpine3.13 as build-php-74

ENV PHP_MAJOR_VERSION=7
ENV PHP_SHORT_VERSION=74

RUN sudo apk --update --no-cache add \
    php7 php7-curl php7-fileinfo php7-iconv php7-json php7-mbstring php7-opcache php7-openssl php7-phar \
    php7-session php7-zip \
    php7-pecl-apcu php7-pecl-uploadprogress php7-pecl-xdebug

FROM druidfi/base:alpine3.13 as build-php-80

ENV PHP_MAJOR_VERSION=8
ENV PHP_SHORT_VERSION=80

RUN sudo apk --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community add libzip && \
    sudo apk --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community add \
    php8 php8-curl php8-fileinfo php8-iconv php8-mbstring php8-opcache php8-openssl php8-phar \
    php8-session php8-zip && \
    sudo apk --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community add \
    php8-pecl-apcu php8-pecl-uploadprogress php8-pecl-xdebug && \
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
    sudo chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${COMPOSER_HOME}

# Fix work iconv library with Alpine
RUN sudo apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Copy configuration files and scripts
COPY files/ /

# Default command
CMD ["php", "-v"]
