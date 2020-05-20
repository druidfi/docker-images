ARG ALPINE_VERSION
ARG COMPOSER_VERSION

FROM composer:${COMPOSER_VERSION} AS composer
FROM druidfi/base:alpine${ALPINE_VERSION} AS baseline

ENV APP_ENV=prod \
    COMPOSER_HOME=/home/${DEFAULT_USER}/.composer \
    # Add /app/vendor/bin to PATH
    PATH="/home/${DEFAULT_USER}/.composer/vendor/bin:${APP_PATH}/vendor/bin:${PATH}"

# Add Composer binary
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Install software
RUN sudo apk --update --no-cache add \
    # PHP extensions
    php7 php7-curl php7-fileinfo php7-iconv php7-json php7-mbstring php7-opcache php7-openssl php7-phar \
    php7-session php7-zip \
    # Xdebug
    #php7-pecl-xdebug \
    # Patch for aplying patches in composer.json
    patch \
    # Unzip for unzipping possible zip packages in composer.json
    unzip && \
    # Install hirak/prestissimo Composer plugin
    composer global require hirak/prestissimo && \
    #
    # Set permissions on Composer home directory
    #
    fix-permissions ${COMPOSER_HOME}

# Fix work iconv library with Alpine
RUN sudo apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# When Alpine 3.7 is not used anymore, remove this line and uncomment php7-pecl-xdebug above
RUN if [ "$ALPINE_VERSION" = "3.7" ] ; then sudo apk --update --no-cache add php7-xdebug ; else sudo apk --update --no-cache add php7-pecl-xdebug ; fi

# Copy configuration files and scripts
COPY files/ /

# Default command
CMD ["sudo", "php", "-v"]
