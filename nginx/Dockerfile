# syntax=docker/dockerfile:1

ARG NGINX_VERSION=1.26

FROM nginx:${NGINX_VERSION}-alpine AS base

ENV BACKEND_SERVICE=app
ENV BACKEND_SERVICE_PORT=9000
ENV NGINX_PORT=8080

# Copy configuration files and scripts
COPY files/base/ /

FROM base AS drupal

# Copy configuration files and scripts
COPY files/drupal/ /
