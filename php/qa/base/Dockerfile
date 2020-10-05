ARG QA_SET

FROM druidfi/php:7.3 AS build

ENV PANTHER_NO_SANDBOX=1
ENV PANTHER_CHROME_DRIVER_BINARY=/usr/lib/chromium/chromedriver
ENV PANTHER_WEB_SERVER_PORT 9800
ENV PANTHER_CHROME_ARGUMENTS '--ignore-certificate-errors'

RUN sudo apk --update --no-cache add \
    # PHP extensions
    php7-dom php7-simplexml php7-tokenizer php7-xml php7-xmlwriter \
    # Chromium for Panther
    chromium chromium-chromedriver && \
    # Install Panther
    composer global require \
        dealerdirect/phpcodesniffer-composer-installer:^0.6 \
        symfony/panther:^0.8

FROM build as drupal

# Install Drupal ruleset for CodeSniffer
RUN composer global require drupal/coder:^8.3

# Default command
CMD ["phpcs", "-i"]

FROM drupal AS drupal-7

# Copy configuration files and scripts
COPY files/drupal_7/ /

FROM drupal AS drupal-8

# Copy configuration files and scripts
COPY files/drupal_8/ /

FROM build AS symfony

RUN composer global require \
        escapestudios/symfony2-coding-standard:^3.11 \
        friendsofphp/php-cs-fixer

# Copy configuration files and scripts
COPY files/symfony/.php_cs.dist /app/.php_cs.dist

# Default command
CMD ["php-cs-fixer", "--version"]

FROM build AS wordpress

# Install Wordpress ruleset for CodeSniffer
RUN composer global require wp-coding-standards/wpcs

# Default command
CMD ["phpcs", "-i"]

FROM ${QA_SET} as final

RUN composer clear-cache && \
    sudo rm /etc/php7/conf.d/xdebug.ini && \
    # Show versions and info
    phpcs --version && \
    phpcs -i
