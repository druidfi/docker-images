ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION

LABEL maintainer="druid.fi"

RUN apk add --no-cache curl

ENTRYPOINT ["/usr/bin/curl"]
