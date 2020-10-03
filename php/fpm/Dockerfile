ARG PHP_VERSION
ARG PHP_SHORT_VERSION

FROM druidfi/php:${PHP_VERSION} AS build

FROM build as build-php-73

RUN sudo apk --update --no-cache add php7-fpm

FROM build as build-php-74

RUN sudo apk --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community add php7-fpm

FROM build-php-${PHP_SHORT_VERSION} as final

# Copy configuration files and scripts
COPY files/ /

# Default command
CMD ["sudo", "-E", "LD_PRELOAD=/usr/lib/preloadable_libiconv.so", "/usr/sbin/php-fpm7", "-F", "-R"]
