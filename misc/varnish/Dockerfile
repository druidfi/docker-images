# See https://github.com/wodby/varnish
FROM wodby/varnish:6 as base

LABEL org.opencontainers.image.authors="Druid".fi maintainer="Druid.fi"
LABEL org.opencontainers.image.source="https://github.com/druidfi/docker-images" repository="https://github.com/druidfi/docker-images"

ENV VARNISH_SECRET=secret \
    VARNISH_BACKEND_HOST=app \
    VARNISH_BACKEND_PORT=8080 \
    VARNISH_CONFIG_PRESET=drupal \
    VARNISH_ALLOW_UNRESTRICTED_PURGE=1
