ARG PHP_VERSION

FROM druidfi/drupal:${PHP_VERSION}-web AS baseline

ARG BRANCH=master

# Install make and create Drupal project
RUN sudo apk --update --no-cache add make && \
    composer create-project druidfi/spell:dev-${BRANCH} ${APP_PATH} --no-interaction && \
    #
    # Install some modules for testing
    #
    composer req drupal/admin_toolbar drupal/paragraphs drupal/pathauto drupal/simplei && \
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
