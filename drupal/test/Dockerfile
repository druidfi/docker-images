ARG PHP_VERSION

FROM druidfi/drupal:${PHP_VERSION}-web AS baseline

ARG BUILD_DATE=${BUILD_DATE}
ARG BRANCH=master

ENV COMPOSER_MEMORY_LIMIT=-1

# Install make and create Drupal project
RUN composer create-project druidfi/spell:dev-${BRANCH} ${APP_PATH} --no-interaction
    #
    # Install some modules for testing
    #
RUN composer req \
        drupal/admin_toolbar \
        drupal/gin \
        drupal/gin_login \
        drupal/gin_toolbar \
        drupal/metatag \
        drupal/olivero \
        drupal/paragraphs \
        drupal/pathauto \
        drupal/simplei \
        drupal/pwa && \
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
