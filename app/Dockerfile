# syntax=docker/dockerfile:1

#
# Envplate
#
FROM alpine AS envplate-builder

ARG REPO=https://github.com/kreuzwerker/envplate/releases/download
ARG VERSION=1.0.3

WORKDIR /tmp
RUN apk add curl

RUN <<EOF
curl -LJ --silent ${REPO}/v${VERSION}/envplate_${VERSION}_Linux_arm64.tar.gz -o envplate_aarch64.tar.gz
curl -LJ --silent ${REPO}/v${VERSION}/envplate_${VERSION}_Linux_x86_64.tar.gz -o envplate_x86_64.tar.gz
tar -xf envplate_$(uname -m).tar.gz
chmod +x envplate
EOF

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
    PHP_SENDMAIL_PATH="/usr/sbin/sendmail -S host.docker.internal:1025 -t" \
    SSH_AUTH_SOCK=/tmp/ssh-agent

WORKDIR ${APP_PATH}

COPY --link --from=composer/composer:2-bin /composer /usr/local/bin/
COPY --link --from=envplate-builder /tmp/envplate /usr/local/bin/ep
COPY --link --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# See https://learn.microsoft.com/en-us/azure/postgresql/single-server/concepts-certificate-rotation#what-change-was-scheduled-to-be-performed-starting-december-2022-122022
ADD --checksum=sha256:5d550643b6400d4341550a9b14aedd0b4fac33ae5deb7d8247b6b4f799c13306 --chmod=0644 \
    https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem /opt/ssl/

RUN <<EOF
apk --no-cache add bash curl doas git make mariadb-client mariadb-connector-c nano neofetch nginx patch tar tini unzip
install-php-extensions apcu bcmath exif gd igbinary msgpack mysqli opcache pdo_mysql redis sockets uploadprogress xdebug zip
addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID}
adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER}
echo "permit nopass keepenv ${DEFAULT_USER} as root" > /etc/doas.d/doas.conf
mkdir -p /home/${DEFAULT_USER}/.composer
chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER} ${APP_PATH}
EOF

COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} files/home/druid/ /home/druid
COPY files/entrypoints/ /entrypoints/
COPY files/etc/ /etc/
COPY files/usr/local/ /usr/local/

SHELL ["/bin/bash", "-c"]
USER ${DEFAULT_USER}

EXPOSE 8080/tcp

ENTRYPOINT ["/sbin/tini", "--", "entrypoint"]
CMD ["doas", "nginx"]
