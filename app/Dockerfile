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
ADD https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem /opt/ssl/

RUN <<EOF
apk --no-cache add bash curl git make mariadb-client mariadb-connector-c nano neofetch nginx patch sudo tar tini unzip
install-php-extensions apcu bcmath exif gd igbinary msgpack mysqli opcache pdo_mysql redis sockets uploadprogress xdebug zip
addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID}
adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER}
echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:SETENV:ALL" > /etc/sudoers.d/${DEFAULT_USER}
chmod 0440 /etc/sudoers.d/${DEFAULT_USER}
mkdir -p /home/${DEFAULT_USER}/.composer
chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER} ${APP_PATH}
chmod 0644 /opt/ssl/*.crt.pem
echo "Set disable_coredump false" > /etc/sudo.conf
EOF

COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} files/home/druid/ /home/druid
COPY files/usr/local/bin/ /usr/local/bin/
COPY files/usr/local/etc/ /usr/local/etc/
COPY files/entrypoints/ /entrypoints/
COPY files/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY files/etc/nginx/fastcgi.conf /etc/nginx/fastcgi.conf
COPY files/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

SHELL ["/bin/bash", "-c"]
USER ${DEFAULT_USER}

EXPOSE 8080/tcp

ENTRYPOINT ["/sbin/tini", "--", "entrypoint"]
CMD ["sudo", "nginx"]
