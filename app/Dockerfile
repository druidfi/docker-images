# syntax=docker/dockerfile:1

#
# Envplate
#
FROM alpine AS envplate-builder

ARG VERSION=1.0.3
ARG TARGETPLATFORM

RUN case ${TARGETPLATFORM} in "linux/amd64") ARCH=x86_64 ;; "linux/arm64") ARCH=arm64 ;; esac && echo "$ARCH" && \
    wget -q https://github.com/kreuzwerker/envplate/releases/download/v${VERSION}/envplate_${VERSION}_Linux_${ARCH}.tar.gz -O /envplate && \
    chmod +x /envplate

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
    PATH="${PATH}:/home/druid/.composer/vendor/bin:/app/vendor/bin" \
    SSH_AUTH_SOCK=/tmp/ssh-agent

WORKDIR ${APP_PATH}

COPY --link --from=composer/composer:2-bin /composer /usr/local/bin/
COPY --link --from=envplate-builder /envplate /usr/local/bin/ep
COPY --link --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk --no-cache add \
    bash curl doas git make mariadb-client mariadb-connector-c neofetch nginx openssh-client patch tar tini && \
    install-php-extensions \
    apcu bcmath exif gd igbinary msgpack mysqli opcache pdo_mysql redis sockets uploadprogress xdebug zip && \
    addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID} && \
    adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER} && \
    mkdir -p /home/${DEFAULT_USER}/.composer && \
    chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER} ${APP_PATH}

COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} files/home/druid/ /home/druid
COPY files/entrypoints/ /entrypoints/
COPY files/etc/ /etc/
COPY files/usr/local/ /usr/local/

# See https://learn.microsoft.com/en-us/azure/postgresql/single-server/concepts-certificate-rotation#what-change-was-scheduled-to-be-performed-starting-december-2022-122022
ADD --checksum=sha256:5d550643b6400d4341550a9b14aedd0b4fac33ae5deb7d8247b6b4f799c13306 --chmod=0644 \
    https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem /opt/ssl/

EXPOSE 8080/tcp

ENTRYPOINT ["/sbin/tini", "--", "entrypoint"]
CMD ["doas", "nginx"]
USER ${DEFAULT_USER}
SHELL ["/bin/bash", "-c"]
