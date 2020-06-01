#
# NOTE! This image is just a just-start for all Alpine-based images.
# It's only purpose is to add maintainer label and set a few ENV variables.
#

ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION

LABEL maintainer="druid.fi"

# All images based on this one will have this ENV var
ENV KIND=druid-docker-image \
    ALPINE_VERSION=${ALPINE_VERSION}
