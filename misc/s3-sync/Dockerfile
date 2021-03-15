ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION

LABEL maintainer="druid.fi"

# All images based on this one will have these ENV vars
ENV KIND=druid-docker-image \
    ALPINE_VERSION=${ALPINE_VERSION}

COPY s3cfg /root/.s3cfg
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh && \
    mkdir /data && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing s3cmd && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
