ARG NODE_VERSION

FROM node:${NODE_VERSION}-alpine as base

LABEL org.opencontainers.image.authors="Druid".fi maintainer="Druid.fi"
LABEL org.opencontainers.image.source="https://github.com/druidfi/docker-images" repository="https://github.com/druidfi/docker-images"

# All images based on this one will have this ENV var
ENV KIND=druid-docker-image

# Install possible needed packages for npm package installation
RUN apk add --no-cache bash g++ gcc git make openssh python3

# Set default workdir
WORKDIR /app
