# syntax=docker/dockerfile:1

ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS base

# All images based on this one will have these ENV vars
ENV KIND=druid-docker-image \
    ALPINE_VERSION=${ALPINE_VERSION}

RUN apk --update --no-cache add curl

ENTRYPOINT ["/usr/bin/curl"]
