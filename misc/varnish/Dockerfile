# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

# See https://github.com/wodby/varnish
FROM wodby/varnish:6 AS base

ENV VARNISH_SECRET=secret \
    VARNISH_BACKEND_HOST=app \
    VARNISH_BACKEND_PORT=8080 \
    VARNISH_CONFIG_PRESET=drupal \
    VARNISH_ALLOW_UNRESTRICTED_PURGE=1
