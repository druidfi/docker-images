# syntax=docker/dockerfile:1
# check=skip=InvalidBaseImagePlatform

### Git downloader for search_api_solr
FROM alpine AS git-downloader

RUN apk --update --no-cache add git

WORKDIR /tmp

RUN git clone https://git.drupalcode.org/project/search_api_solr.git

#
# Final
#
FROM solr:9.8.1-slim AS solr

ENV SOLR_HEAP="1024m" \
    SOLR_DEFAULT_CONFIG_SET="search_api_solr_4.3.8"

COPY --from=git-downloader /tmp/search_api_solr/jump-start/solr9/config-set/ /opt/docker-solr/configsets/search_api_solr_4.3.8/

RUN test -f /opt/docker-solr/configsets/search_api_solr_4.3.8/solrconfig.xml || exit 1
