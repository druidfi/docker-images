ARG PHP_VERSION

FROM druidfi/php:${PHP_VERSION} AS baseline

LABEL maintainer="druid.fi"

# Install software
RUN apk --update --no-cache add \
    # PHP extensions
    php7-fpm

# Copy configuration files and scripts
COPY files/ /

# Default command
CMD ["/usr/sbin/php-fpm7", "-F", "-R"]
