ARG BASE_IMAGE_NAME
ARG PHP_VERSION
ARG PHP_SHORT_VERSION

FROM ${BASE_IMAGE_NAME}:${PHP_VERSION} AS fpm

RUN sudo apk --update --no-cache add php${PHP_MAJOR_VERSION}-fpm

# Copy configuration files and scripts
COPY files/etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf

FROM fpm as build-php-fpm-7

# Default command
CMD ["/usr/sbin/php-fpm7", "-F", "-R"]

FROM build-php-fpm-7 as build-php-fpm-73
FROM build-php-fpm-7 as build-php-fpm-74

FROM fpm as build-php-fpm-80

# Default command
CMD ["/usr/sbin/php-fpm8", "-F", "-R"]

FROM build-php-fpm-${PHP_SHORT_VERSION} as final
