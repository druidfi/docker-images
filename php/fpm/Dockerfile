ARG BASE_IMAGE_NAME
ARG PHP_VERSION
ARG PHP_SHORT_VERSION

FROM ${BASE_IMAGE_NAME}:${PHP_VERSION} AS build

FROM build as build-php-73

RUN sudo apk --update --no-cache add php7-fpm

# Copy configuration files and scripts
COPY files/etc/php7/php-fpm.d/www.conf /etc/php7/php-fpm.d/www.conf

# Default command
CMD ["sudo", "-E", "LD_PRELOAD=/usr/lib/preloadable_libiconv.so", "/usr/sbin/php-fpm7", "-F", "-R"]

FROM build as build-php-74

RUN sudo apk --update --no-cache add php7-fpm

# Copy configuration files and scripts
COPY files/etc/php7/php-fpm.d/www.conf /etc/php7/php-fpm.d/www.conf

# Default command
CMD ["sudo", "-E", "LD_PRELOAD=/usr/lib/preloadable_libiconv.so", "/usr/sbin/php-fpm7", "-F", "-R"]

FROM build as build-php-80

RUN sudo apk --update --no-cache add php8-fpm

# Copy configuration files and scripts
COPY files/etc/php8/php-fpm.d/www.conf /etc/php8/php-fpm.d/www.conf

# Default command
CMD ["sudo", "-E", "LD_PRELOAD=/usr/lib/preloadable_libiconv.so", "/usr/sbin/php-fpm8", "-F", "-R"]

FROM build-php-${PHP_SHORT_VERSION} as final
