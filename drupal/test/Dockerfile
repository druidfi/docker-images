ARG PHP_VERSION

FROM druidfi/drupal:${PHP_VERSION}-web AS baseline

LABEL maintainer="druid.fi"

ARG USER=druid
ARG APP=/app
ARG BRANCH=master

# Install make and create Drupal project
RUN apk --update --no-cache add make && \
    composer create-project druidfi/spell:dev-${BRANCH} ${APP} --no-interaction && \
    mkdir ${APP}/public/sites/default/files && \
    chown -R ${USER}:${USER} ${APP}/public/sites/default/files && \
    composer clear-cache && \
    rm -rf ${APP}/.git
