ARG PHP_VERSION

FROM druidfi/drupal-web:${PHP_VERSION}

LABEL maintainer="druid.fi"

# Install MariaDB
RUN apk --update --no-cache add \
    mysql mysql-client
