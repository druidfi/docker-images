ARG PHP_VERSION

FROM druidfi/php:${PHP_VERSION}-fpm AS baseline

ENV DRUPAL_DB_NAME=drupal \
    DRUPAL_DB_USER=drupal \
    DRUPAL_DB_PASS=drupal \
    DRUPAL_DB_HOST=db \
    DRUPAL_DB_PORT=3306 \
    SSH_AUTH_SOCK=/tmp/ssh-agent

RUN sudo apk --update --no-cache add \
    #
    # Install ImageMagick
    #
    imagemagick \
    #
    # PHP extensions needed by Drupal
    #
    php7-bcmath php7-ctype php7-dom php7-exif php7-gd php7-intl php7-pdo php7-pdo_mysql php7-simplexml php7-sockets \
    php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zlib \
    #
    # Install MySQL client
    #
    mysql-client \
    #
    # openssh and rsync are needed for using Drush aliases and connecting to them
    #
    openssh rsync

# Copy configuration files and scripts
COPY files/ /
