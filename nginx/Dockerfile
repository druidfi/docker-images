ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION}-alpine as base

LABEL maintainer="druid.fi"

ENV BACKEND_SERVICE=app
ENV BACKEND_SERVICE_PORT=9000
ENV NGINX_PORT=8080

# Copy configuration files and scripts
COPY files/base/ /

FROM base as drupal

# Copy configuration files and scripts
COPY files/drupal/ /
