ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="druid.fi"

RUN apk --no-cache add dnsmasq

EXPOSE 53 53/udp

ENTRYPOINT ["dnsmasq", "-k"]
