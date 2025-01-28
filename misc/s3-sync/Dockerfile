# syntax=docker/dockerfile:1

ARG ALPINE_VERSION=3.20.5

FROM alpine:${ALPINE_VERSION} AS base

# All images based on this one will have these ENV vars
ENV KIND=druid-docker-image

COPY s3cfg /root/.s3cfg
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh && \
    mkdir /data && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing s3cmd && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
