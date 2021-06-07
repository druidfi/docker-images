ARG NGINX_VERSION=1.20

FROM nginx:${NGINX_VERSION}-alpine as base

LABEL maintainer="druid.fi"

# Copy configuration files and scripts
COPY files/base/ /

FROM base as drupal

# Copy configuration files and scripts
COPY files/drupal/ /
