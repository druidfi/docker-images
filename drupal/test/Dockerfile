ARG PHP_VERSION

FROM druidfi/drupal:${PHP_VERSION}-web AS baseline

ARG BRANCH=master

# Install make and create Drupal project
RUN sudo apk --update --no-cache add make && \
    composer create-project druidfi/spell:dev-${BRANCH} ${APP_PATH} --no-interaction && \
    mkdir ${APP_PATH}/public/sites/default/files && \
    chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${APP_PATH}/public/sites/default/files && \
    composer clear-cache && \
    rm -rf ${APP_PATH}/.git
