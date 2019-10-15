ARG PHP_VERSION

FROM druidfi/drupal-web:${PHP_VERSION}

LABEL maintainer="druid.fi"

ENV DRUPAL_DB_HOST=127.0.01 \
    DRUPAL_DB_NAME=drupal \
    DRUPAL_DB_USER=drupal \
    DRUPAL_DB_PASS=drupal \
    DRUPAL_DB_PORT=3306

# Install MariaDB
RUN apk --update --no-cache add \
    mysql mysql-client
