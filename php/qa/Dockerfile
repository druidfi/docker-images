ARG PHP_VERSION
ARG PHP_SHORT_VERSION

FROM druidfi/php:${PHP_VERSION} AS build

FROM build as build-php-73

RUN sudo apk --update --no-cache add \
    # PHP extensions
    php7-dom php7-simplexml php7-tokenizer php7-xml php7-xmlwriter

COPY files/99_custom.ini /etc/php7/conf.d/99_custom.ini

FROM build as build-php-74

RUN sudo apk --update --no-cache add \
    # PHP extensions
    php7-dom php7-simplexml php7-tokenizer php7-xml php7-xmlwriter

COPY files/99_custom.ini /etc/php7/conf.d/99_custom.ini

FROM build-php-${PHP_SHORT_VERSION} as final

# Install coding standards & tools with Composer
RUN composer global require --no-progress \
        dealerdirect/phpcodesniffer-composer-installer:^0.7 \
        drupal/coder:^8.3 \
        escapestudios/symfony2-coding-standard:^3.11 \
        wp-coding-standards/wpcs \
        phpcompatibility/php-compatibility \
        friendsofphp/php-cs-fixer && \
    composer clear-cache && \
    sudo rm /etc/php7/conf.d/xdebug.ini

COPY files/drupal/phpcs.xml /app/phpcs.xml
COPY files/symfony/.php_cs.dist /app/.php_cs.dist

# Default command
CMD ["php", "-v"]
