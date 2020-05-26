ARG PHP_VERSION

FROM druidfi/php:${PHP_VERSION} AS baseline

COPY composer.json /app/composer.json

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN sudo apk --update --no-cache add \
    # PHP extensions
    php7-ctype php7-tokenizer && \
    # fix work iconv library with alphine
    sudo apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv && \
    #
    composer install --prefer-dist && \
    composer clear-cache && \
    sudo rm /etc/php7/conf.d/xdebug.ini && \
    # Show version
    rector --version # && ls -lahR /home/druid/.composer

# Copy configuration files and scripts
COPY rector.yml /app/rector.yml

# Default command
CMD ["rector"]
