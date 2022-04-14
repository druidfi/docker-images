FROM --platform=linux/amd64 wodby/solr:8 as solr-8-amd64

FROM --platform=linux/arm64 arm64v8/solr:8.11-slim as solr-8-arm64

RUN rm -rf /opt/docker-solr/configsets/

COPY --from=wodby/solr:8 /opt/docker-solr/configsets/ /opt/docker-solr/configsets/

ENV SOLR_HEAP="1024m" \
    SOLR_DEFAULT_CONFIG_SET="search_api_solr_4.2.1"

FROM solr-8-${TARGETARCH} as solr

LABEL org.opencontainers.image.authors="Druid".fi maintainer="Druid.fi"
LABEL org.opencontainers.image.source="https://github.com/druidfi/docker-images" repository="https://github.com/druidfi/docker-images"
