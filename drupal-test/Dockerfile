ARG PHP_VERSION

FROM composer AS builder

ARG BRANCH=main

WORKDIR /app

# Install make and create Drupal project
RUN composer create-project --ignore-platform-reqs --no-dev --no-progress --no-interaction druidfi/spell:dev-${BRANCH} .

# Install some modules for testing
RUN composer req --ignore-platform-reqs --no-progress --no-interaction \
        drupal/admin_toolbar \
        drupal/gin \
        drupal/gin_login \
        drupal/gin_toolbar \
        drupal/metatag \
        drupal/paragraphs \
        drupal/pathauto \
        drupal/simplei \
        drupal/pwa

FROM druidfi/drupal-web:php-${PHP_VERSION} AS baseline

COPY --from=builder ${APP_PATH}/composer.* ${APP_PATH}/
COPY --from=builder ${APP_PATH}/conf/ ${APP_PATH}/conf/
COPY --from=builder ${APP_PATH}/drush/ ${APP_PATH}/drush/
COPY --from=builder ${APP_PATH}/public/ ${APP_PATH}/public/
COPY --from=builder ${APP_PATH}/vendor/ ${APP_PATH}/vendor/

# Set up file folders
RUN mkdir ${APP_PATH}/public/sites/default/files && \
    chown -R www-data:www-data ${APP_PATH}/public/sites/default/files
