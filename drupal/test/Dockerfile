ARG PHP_VERSION

FROM druidfi/drupal:${PHP_VERSION}-web AS baseline

ARG BUILD_DATE=${BUILD_DATE}
ARG BRANCH=master

# Install make and create Drupal project
RUN sudo apk --update --no-cache add make && \
    COMPOSER_MEMORY_LIMIT=-1 composer create-project druidfi/spell:dev-${BRANCH} ${APP_PATH} --no-interaction && \
    #
    # Install some modules for testing
    #
    composer req drupal/admin_toolbar drupal/metatag drupal/paragraphs drupal/pathauto drupal/pwa drupal/simplei && \
    #
    # Set up file folders
    #
    mkdir ${APP_PATH}/public/sites/default/files && \
    chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${APP_PATH}/public/sites/default/files && \
    #
    # Cleanup
    #
    composer clear-cache && \
    rm -rf ${APP_PATH}/.git
