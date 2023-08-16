# syntax=docker/dockerfile:1

FROM php-base

ENV KIND=druid-docker-image \
    APP_PATH=/app \
    DEFAULT_USER=druid \
    DEFAULT_USER_UID=1000 \
    APP_ENV=prod \
    COMPOSER_HOME=/home/druid/.composer \
    PATH="${PATH}:/home/druid/.composer/vendor/bin:/app/vendor/bin"

COPY --from=composer/composer:2-bin /composer /usr/bin/composer

# See https://docs.microsoft.com/en-us/azure/mysql/howto-configure-ssl
ADD https://cacerts.digicert.com/BaltimoreCyberTrustRoot.crt.pem /opt/ssl/
# See https://learn.microsoft.com/en-us/azure/postgresql/single-server/concepts-certificate-rotation#what-change-was-scheduled-to-be-performed-starting-december-2022-122022
ADD https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem /opt/ssl/

RUN apk --no-cache add bash curl git make nano neofetch nginx sudo tar tini && \
    neofetch

RUN <<EOF
apk update && apk upgrade
apk --no-cache add bash curl git make nano neofetch nginx patch sudo tar tini unzip
neofetch
addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID}
adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER}
echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:SETENV:ALL" > /etc/sudoers.d/${DEFAULT_USER}
chmod 0440 /etc/sudoers.d/${DEFAULT_USER}
chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}
install -o ${DEFAULT_USER} -g ${DEFAULT_USER} ${APP_PATH}
install -o ${DEFAULT_USER} -g ${DEFAULT_USER} -d ${COMPOSER_HOME}
chmod 0644 /opt/ssl/*.crt.pem
echo "Set disable_coredump false" > /etc/sudo.conf
EOF

COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} files/home/druid/ /home/druid
COPY files/usr/local/bin/ /usr/local/bin/

SHELL ["/bin/bash", "-c"]
USER ${DEFAULT_USER}

WORKDIR ${APP_PATH}
