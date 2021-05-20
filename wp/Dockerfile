ARG PHP_VERSION
ARG PHP_SHORT_VERSION

FROM druidfi/php:${PHP_VERSION}-fpm AS build

RUN sudo apk --update --no-cache add imagemagick mysql-client nginx

FROM build as build-php-73

RUN sudo apk --update --no-cache add \
    php7-bcmath php7-ctype php7-dom php7-exif php7-gd php7-intl php7-mysqli php7-pdo php7-pdo_mysql php7-simplexml php7-sockets \
    php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zlib

FROM build as build-php-74

RUN sudo apk --update --no-cache add \
    php7-bcmath php7-ctype php7-dom php7-exif php7-gd php7-intl php7-mysqli php7-pdo php7-pdo_mysql php7-simplexml php7-sockets \
    php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zlib

FROM build as build-php-80

RUN sudo apk --update --no-cache add \
    php8-bcmath php8-ctype php8-dom php8-exif php8-gd php8-intl php8-pdo php8-pdo_mysql php8-simplexml php8-sockets \
    php8-tokenizer php8-xml php8-xmlreader php8-xmlwriter php8-zlib

FROM build-php-${PHP_SHORT_VERSION} as final

# Copy configuration files and scripts
COPY files/ /

COPY composer.* /app/

# Install Wordpress
RUN composer install --no-dev --no-progress

# Copy Wordpress configuration
COPY wp-config.php /app/public/wp-config.php

# Expose port 8080 for Nginx
EXPOSE 8080

# Default command: Start up multiple services via entrypoint
CMD ["entrypoint"]

USER ${DEFAULT_USER}
