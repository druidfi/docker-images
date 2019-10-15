ARG PHP_VERSION

FROM druidfi/drupal:${PHP_VERSION}

LABEL maintainer="druid.fi"

# Install Nginx
RUN apk --update --no-cache add nginx

# Copy configuration files and scripts
COPY files/ /
