# syntax=docker/dockerfile:1

#
# App image
#
FROM php-base

ENV KIND=druid-docker-image \
    APP_PATH=/app \
    DEFAULT_USER=druid \
    DEFAULT_USER_UID=1000 \
    APP_ENV=prod \
    COMPOSER_HOME=/home/druid/.composer \
    COMPOSER_AUDIT_ABANDONED=report \
    COMPOSER_FUND=0 \
    PATH="${PATH}:/home/druid/.composer/vendor/bin:/app/vendor/bin" \
    DRUPAL_DB_NAME=drupal \
    DRUPAL_DB_USER=drupal \
    DRUPAL_DB_PASS=drupal \
    DRUPAL_DB_HOST=db \
    DRUPAL_DB_PORT=3306

WORKDIR ${APP_PATH}

COPY --link --from=composer/composer:2.9-bin /composer /usr/local/bin/
COPY --link --from=amazeeio/envplate:26.3.0 /usr/local/bin/ep /usr/local/bin/
COPY --link --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk --no-cache add \
    bash curl doas fastfetch git make \
    mariadb-client mariadb-connector-c \
    msmtp nano nginx openssh-client patch rsync ssmtp tar tini unzip && \
    install-php-extensions \
    apcu bcmath exif gd igbinary imagick opcache pdo_mysql redis sockets uploadprogress xdebug zip && \
    addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID} && \
    adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER} && \
    adduser ${DEFAULT_USER} www-data && \
    mkdir -p /home/${DEFAULT_USER}/.composer && \
    curl -sSf https://composer.github.io/releases.pub -o /home/${DEFAULT_USER}/.composer/keys.tags.pub && \
    curl -sSf https://composer.github.io/snapshots.pub -o /home/${DEFAULT_USER}/.composer/keys.dev.pub && \
    chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER} ${APP_PATH} && \
    chmod -R a+rwx /var/lib/nginx /var/log/nginx && \
    curl -sSL https://github.com/Smile-SA/gdpr-dump/releases/latest/download/gdpr-dump.phar -o /usr/local/bin/gdpr-dump && \
    chmod +x /usr/local/bin/gdpr-dump && \
    gdpr-dump --version

COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} rootfs/home/druid/ /home/druid
COPY rootfs/entrypoints/ /entrypoints/
COPY rootfs/etc/ /etc/
COPY rootfs/usr/local/ /usr/local/

# https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-connect-tls-ssl
RUN mkdir -p /opt/ssl
COPY --chmod=644 rootfs/opt/ssl/DigiCertGlobalRootCA.crt.pem /opt/ssl/

EXPOSE 8080/tcp

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["entrypoint"]
USER ${DEFAULT_USER}
SHELL ["/bin/bash", "-c"]
