# syntax=docker/dockerfile:1.3-labs

ARG MYSQL_VERSION

FROM mysql:${MYSQL_VERSION} as base

LABEL org.opencontainers.image.authors="Druid".fi maintainer="Druid.fi"
LABEL org.opencontainers.image.source="https://github.com/druidfi/docker-images" repository="https://github.com/druidfi/docker-images"

ARG DRUPAL_CONF="/etc/mysql/conf.d/drupal.cnf"

ENV KIND=druid-docker-image \
    MYSQL_DATABASE=drupal \
    MYSQL_USER=drupal \
    MYSQL_PASSWORD=drupal \
    MYSQL_ROOT_PASSWORD=drupal

RUN <<EOF
printf '[mysqld]\nmax_allowed_packet=16M' >> ${DRUPAL_CONF}
if [ "${MYSQL_MAJOR}" = "8.0" ] ;
    then printf '\ndefault-authentication-plugin=mysql_native_password' >> ${DRUPAL_CONF} ;
fi
cat ${DRUPAL_CONF}
EOF
