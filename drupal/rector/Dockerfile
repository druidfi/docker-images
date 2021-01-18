ARG PHP_VERSION

FROM druidfi/php:${PHP_VERSION} AS baseline

ARG DRP=/opt/drupal-rector

COPY composer.json ${DRP}/composer.json
COPY rector.yml ${DRP}/rector.yml

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN sudo chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${DRP} && \
    sudo apk --update --no-cache add \
    # PHP extensions
    php7-ctype php7-tokenizer && \
    # fix work iconv library with alphine
    sudo apk add --no-cache --allow-untrusted gnu-libiconv && \
    #
    # Install drupal-rector
    #
    composer --working-dir=${DRP} install --prefer-dist && \
    composer clear-cache && \
    sudo rm /etc/php7/conf.d/xdebug.ini && \
    # Show version
    ${DRP}/vendor/bin/rector --version

# Default command
CMD ["${DRP}/vendor/bin/rector"]
