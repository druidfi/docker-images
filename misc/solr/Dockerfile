# syntax=docker/dockerfile:1
# check=skip=InvalidBaseImagePlatform

### Git downloader for search_api_solr
FROM alpine AS git-downloader

RUN apk --update --no-cache add git

WORKDIR /tmp

RUN git clone https://git.drupalcode.org/project/search_api_solr.git


#
# AMD64
#
FROM --platform=linux/amd64 solr:9.8.1-slim AS solr-9-amd64

ENV ARCH=amd64

#
# ARM64
#
FROM --platform=linux/arm64 arm64v8/solr:9.8.1-slim AS solr-9-arm64

ENV ARCH=arm64

#
# Final
#
FROM solr-9-${TARGETARCH} AS solr

ENV SOLR_HEAP="1024m" \
    SOLR_DEFAULT_CONFIG_SET="search_api_solr_4.3.8"

RUN rm -rf /opt/docker-solr/configsets/

COPY --from=git-downloader /tmp/search_api_solr/jump-start/solr9/config-set/ /opt/docker-solr/configsets/
