# syntax=docker/dockerfile:1

ARG SOLR_VERSION=9.10.1
ARG SEARCH_API_SOLR_VERSION=4.3.14

### Git downloader for search_api_solr
FROM alpine AS search_api_solr

ARG SEARCH_API_SOLR_VERSION

ADD https://git.drupalcode.org/project/search_api_solr.git#${SEARCH_API_SOLR_VERSION} /search_api_solr

#
# Final
#
FROM solr:${SOLR_VERSION} AS solr

ENV SOLR_HEAP="1024m" \
    SOLR_MODULES="extraction,langid,ltr,analysis-extras" \
    SOLR_ULIMIT_CHECKS="false"

COPY --from=search_api_solr /search_api_solr/jump-start/solr9/config-set /solr-conf/conf

RUN test -f /solr-conf/conf/schema.xml && \
    cat /solr-conf/conf/schema.xml | grep drupal || \
    exit 1

CMD ["solr-precreate", "drupal", "/solr-conf"]
