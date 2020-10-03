ARG PHP_VERSION
ARG PHP_SHORT_VERSION

FROM druidfi/php-pecl:uploadprogress-${PHP_VERSION} as uploadprogress
FROM druidfi/php:${PHP_VERSION}-fpm AS build

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
    # Install MySQL client
    #
    mysql-client \
    #
    # openssh and rsync are needed for using Drush aliases and connecting to them
    #
    openssh rsync && \
    #
    # Create some folders for Drush
    #
    mkdir -p /home/${DEFAULT_USER}/.drush /home/${DEFAULT_USER}/drush-backups/drupal

FROM build as build-php-73

RUN sudo apk --update --no-cache add \
    php7-bcmath php7-ctype php7-dom php7-exif php7-gd php7-intl php7-pdo php7-pdo_mysql php7-simplexml php7-sockets \
    php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zlib

FROM build as build-php-74

RUN sudo apk --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community add \
    php7-bcmath php7-ctype php7-dom php7-exif php7-gd php7-intl php7-pdo php7-pdo_mysql php7-simplexml php7-sockets \
    php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zlib

FROM build-php-${PHP_SHORT_VERSION} as final

# Copy configuration files and scripts
COPY files/ /

# Copy uploadprogress extension
COPY --from=uploadprogress /uploadprogress.so /usr/lib/php7/modules/uploadprogress.so

USER root

RUN echo 'extension=uploadprogress.so' > /etc/php7/conf.d/20_uploadprogress.ini

USER ${DEFAULT_USER}
