ARG NODE_VERSION

FROM node:${NODE_VERSION}-alpine as base

LABEL maintainer="druid.fi"

# All images based on this one will have this ENV var
ENV KIND=druid-docker-image

# Install possible needed packages for npm package installation
RUN apk add --no-cache bash g++ gcc git make openssh python3

# Set default workdir
WORKDIR /app
