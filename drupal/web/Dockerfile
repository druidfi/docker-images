# syntax=docker/dockerfile:1.3-labs

ARG BASE_DRUPAL_IMAGE_NAME
ARG PHP_VERSION

FROM ${BASE_DRUPAL_IMAGE_NAME}:php-${PHP_VERSION} AS base

# Install Nginx
RUN sudo -s <<EOF
apk --update --no-cache add nginx
EOF

# Copy configuration files and scripts
COPY files/entrypoints/* /entrypoints

# Copy Nginx configuration
COPY files/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY files/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Expose port 8080 for Nginx
EXPOSE 8080

# Default command: Start up multiple services via entrypoint
CMD ["entrypoint"]

FROM base as test

RUN echo "let's do tests!" && exit 1

FROM base as final
