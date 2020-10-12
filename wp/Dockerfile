ARG NGINX_VERSION
ARG PHP_VERSION

FROM druidfi/nginx:${NGINX_VERSION} AS nginx
FROM druidfi/php:${PHP_VERSION}-fpm AS baseline

RUN sudo apk --update --no-cache add \
    #
    # Install ImageMagick
    #
    imagemagick \
    #
    # PHP extensions needed by WordPress
    #
    php7-bcmath php7-ctype php7-dom php7-exif php7-gd php7-intl php7-mysqli php7-pdo php7-pdo_mysql php7-simplexml php7-sockets \
    php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zlib \
    #
    # Install MySQL client
    #
    mysql-client \
    #
    # Install Nginx
    #
    nginx

# Copy configuration files and scripts
COPY files/ /

COPY composer.* /app/

# Install Wordpress
RUN composer install --no-dev

# Copy Wordpress configuration
COPY wp-config.php /app/public/wp-config.php

# Copy Nginx configuration
COPY --from=nginx /etc/nginx/nginx.conf /etc/nginx/nginx.conf

# Expose port 8080 for Nginx
EXPOSE 8080

# Default command: Start up multiple services via entrypoint
CMD ["entrypoint"]
