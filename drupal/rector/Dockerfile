ARG PHP_VERSION

FROM druidfi/php:${PHP_VERSION} AS baseline

ENV DRUPAL_RECTOR_VERSION=dev-master

RUN sudo apk --update --no-cache add \
    # PHP extensions
    php7-ctype php7-tokenizer && \
    #
    composer global require palantirnet/drupal-rector:${DRUPAL_RECTOR_VERSION} && \
    composer clear-cache && \
    sudo rm /etc/php7/conf.d/xdebug.ini && \
    # Show version
    rector --version # && ls -lahR /home/druid/.composer

# Copy configuration files and scripts
COPY rector.yml /app/rector.yml

# Default command
CMD ["rector"]
