ARG ALPINE_VERSION

FROM druidfi/base:alpine${ALPINE_VERSION} AS baseline

ENV APP_ENV=prod \
    COMPOSER_HOME=/home/${DEFAULT_USER}/.composer \
    # Add /app/vendor/bin to PATH
    PATH="/home/${DEFAULT_USER}/.composer/vendor/bin:${APP_PATH}/vendor/bin:${PATH}"

# Download mhsendmail binary
COPY binaries /usr/local/bin/mhsendmail

# Install software
RUN sudo apk --update --no-cache add \
    # PHP extensions
    php7 php7-curl php7-fileinfo php7-iconv php7-json php7-mbstring php7-opcache php7-openssl php7-phar \
    php7-session php7-zip \
    # Pecl extensions: uncomment this when Alpine 3.7 is not used anymore
    #php7-pecl-xdebug php7-pecl-apcu \
    # Patch for aplying patches in composer.json
    patch \
    # Unzip for unzipping possible zip packages in composer.json
    unzip && \
    # Install Composer
    sudo php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --filename=composer && \
    # Install hirak/prestissimo Composer plugin
    composer global require hirak/prestissimo && \
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

# When Alpine 3.7 is not used anymore, remove this line and uncomment php7-pecl-xdebug php7-pecl-apcu above
RUN if [ "$ALPINE_VERSION" = "3.7" ] ; then sudo apk --update --no-cache add php7-xdebug php7-apcu ; else sudo apk --update --no-cache add php7-pecl-xdebug php7-pecl-apcu ; fi

# Copy configuration files and scripts
COPY files/ /

# Default command
CMD ["sudo", "php", "-v"]
