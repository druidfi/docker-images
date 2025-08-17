# syntax=docker/dockerfile:1
# check=skip=InvalidBaseImagePlatform

### Git downloader for search_api_solr
FROM alpine AS search_api_solr

ADD https://git.drupalcode.org/project/search_api_solr.git#4.3.8 /search_api_solr

#
# Final
#
FROM solr:9.8.1 AS solr

ENV SOLR_HEAP="1024m" \
    SOLR_MODULES="extraction,langid,ltr,analysis-extras" \
    SOLR_ULIMIT_CHECKS="false"

COPY --from=search_api_solr /search_api_solr/jump-start/solr9/config-set /solr-conf/conf

RUN test -f /solr-conf/conf/schema.xml && \
    cat /solr-conf/conf/schema.xml | grep drupal || \
    exit 1

CMD ["solr-precreate", "drupal", "/solr-conf"]
