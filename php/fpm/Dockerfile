ARG PHP_VERSION

FROM druidfi/php:${PHP_VERSION} AS baseline

# Install software
RUN sudo apk --update --no-cache add \
    # PHP extensions
    php7-fpm

# Copy configuration files and scripts
COPY files/ /

# Default command
CMD ["sudo", "-E", "LD_PRELOAD=/usr/lib/preloadable_libiconv.so", "/usr/sbin/php-fpm7", "-F", "-R"]
