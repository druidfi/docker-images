# syntax=docker/dockerfile:1
# check=skip=InvalidBaseImagePlatform

#
# AMD64
#
FROM --platform=linux/amd64 solr:8.11-slim AS solr-8-amd64

ENV ARCH=amd64

#
# ARM64
#
FROM --platform=linux/arm64 arm64v8/solr:9.8-slim AS solr-8-arm64

ENV ARCH=arm64

#
# Final
#
FROM solr-8-${TARGETARCH} AS solr

ENV SOLR_HEAP="1024m" \
    SOLR_DEFAULT_CONFIG_SET="search_api_solr_4.3.0"

RUN rm -rf /opt/docker-solr/configsets/

COPY --from=wodby/solr:8 /opt/docker-solr/configsets/ /opt/docker-solr/configsets/
