ARG BASE_IMAGE_NAME
ARG PHP_VERSION

FROM ${BASE_IMAGE_NAME}:${PHP_VERSION} AS final

RUN sudo apk --update --no-cache add php${PHP_MAJOR_VERSION}-fpm

# Copy configuration files and scripts
COPY files/etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf

# Default command
CMD ["sudo", "-E", "LD_PRELOAD=/usr/lib/preloadable_libiconv.so", "/usr/sbin/php-fpm${PHP_MAJOR_VERSION}", "-F", "-R"]
