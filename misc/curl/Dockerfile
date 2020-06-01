ARG ALPINE_VERSION

FROM druidfi/base-init:alpine${ALPINE_VERSION}

RUN apk --update --no-cache add curl

ENTRYPOINT ["/usr/bin/curl"]
