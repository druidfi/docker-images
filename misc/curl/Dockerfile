ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} as base

LABEL org.opencontainers.image.authors="Druid.fi" maintainer="Druid.fi"
LABEL org.opencontainers.image.source="https://github.com/druidfi/docker-images" repository="https://github.com/druidfi/docker-images"

# All images based on this one will have these ENV vars
ENV KIND=druid-docker-image \
    ALPINE_VERSION=${ALPINE_VERSION}

RUN apk --update --no-cache add curl

ENTRYPOINT ["/usr/bin/curl"]
