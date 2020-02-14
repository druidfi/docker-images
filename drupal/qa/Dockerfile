ARG PHP_VERSION

FROM druidfi/php:${PHP_VERSION}-fpm AS baseline

LABEL maintainer="druid.fi"

ARG DPCI_VERSION=^0.6
ARG DRUPAL_CODER_VERSION=^8.3
ARG PANTHER_VERSION=^0.6

ENV PANTHER_NO_SANDBOX=1
ENV PANTHER_CHROME_DRIVER_BINARY=/usr/lib/chromium/chromedriver
ENV PANTHER_WEB_SERVER_PORT 9800
ENV PANTHER_CHROME_ARGUMENTS '--ignore-certificate-errors'

RUN apk --update --no-cache add \
    # PHP extensions
    php7-dom php7-simplexml php7-tokenizer php7-xml php7-xmlwriter \
    # Chromium for Panther
    chromium chromium-chromedriver && \
    #
    composer global require \
        dealerdirect/phpcodesniffer-composer-installer:${DPCI_VERSION} \
        drupal/coder:${DRUPAL_CODER_VERSION} \
        symfony/panther:${PANTHER_VERSION} && \
    composer clear-cache && \
    rm /etc/php7/conf.d/xdebug.ini && \
    # Show versions and info
    phpcs --version && \
    phpcs -i

# Copy configuration files and scripts
COPY files/ /

# Default command
CMD ["phpcs", "-i"]
