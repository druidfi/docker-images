ARG ALPINE_VERSION

FROM druidfi/base-init:alpine${ALPINE_VERSION}

RUN apk --update --no-cache add dnsmasq

EXPOSE 53 53/udp

ENTRYPOINT ["dnsmasq", "-k"]
