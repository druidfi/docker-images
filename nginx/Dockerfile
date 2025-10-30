# syntax=docker/dockerfile:1

ARG NGINX_VERSION=1.28

FROM nginx:${NGINX_VERSION}-alpine AS base

ENV BACKEND_SERVICE=app
ENV BACKEND_SERVICE_PORT=9000
ENV NGINX_PORT=8080

# Copy configuration files and scripts
COPY rootfs/base/ /

FROM base AS drupal

# Copy configuration files and scripts
COPY rootfs/drupal/ /

FROM base AS placeholder

# Copy configuration files and scripts
COPY rootfs/placeholder/ /
