# syntax=docker/dockerfile:1.6

ARG PHP_SHORT_VERSION

FROM base as php-base

FROM php-base as php-base-82

RUN apk add --no-cache php-8.2 php-8.2-pdo php-8.2-pdo_mysql php-8.2-mysqlnd php-8.2-gd php-8.2-curl

FROM php-base as php-base-83

RUN apk add --no-cache php-8.3 php-8.3-pdo php-8.3-pdo_mysql php-8.3-mysqlnd php-8.3-gd php-8.3-curl

#
# App image
#
FROM php-base-${PHP_SHORT_VERSION} as app

ENV KIND=druid-docker-image \
    APP_PATH=/app \
    DEFAULT_USER=druid \
    DEFAULT_USER_UID=1000 \
    APP_ENV=prod \
    COMPOSER_HOME=/home/druid/.composer \
    COMPOSER_AUDIT_ABANDONED=report \
    COMPOSER_FUND=0 \
    PATH="${PATH}:/home/druid/.composer/vendor/bin:/app/vendor/bin" \
    SSH_AUTH_SOCK=/tmp/ssh-agent

WORKDIR ${APP_PATH}

COPY --link --from=composer/composer:2-bin /composer /usr/local/bin/
COPY --link --from=amazeeio/envplate:v1.0.3 /usr/local/bin/ep /usr/local/bin/ep

RUN apk update && \
    apk --no-cache add \
    bash curl doas git make mariadb-client mariadb-connector-c neofetch nginx openssh-client patch tar tini && \
    addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID} && \
    adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER} && \
    mkdir -p /home/${DEFAULT_USER}/.composer && \
    chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER} ${APP_PATH} && \
    chmod -R a+rwx /var/lib/nginx /var/log/nginx

COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} files/home/druid/ /home/druid
COPY files/entrypoints/ /entrypoints/
COPY files/etc/ /etc/
COPY files/usr/local/ /usr/local/

# See https://learn.microsoft.com/en-us/azure/postgresql/single-server/concepts-certificate-rotation#what-change-was-scheduled-to-be-performed-starting-december-2022-122022
ADD --checksum=sha256:5d550643b6400d4341550a9b14aedd0b4fac33ae5deb7d8247b6b4f799c13306 --chmod=0644 \
    https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem /opt/ssl/

EXPOSE 8080/tcp

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["entrypoint"]
USER ${DEFAULT_USER}
SHELL ["/bin/bash", "-c"]
