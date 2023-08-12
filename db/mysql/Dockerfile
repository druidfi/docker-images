# syntax=docker/dockerfile:1.4

ARG MYSQL_SHORT_VERSION

FROM --platform=linux/arm64 biarms/mysql:5.7 as mysql-57-arm64
FROM --platform=linux/amd64 mysql:5.7 as mysql-57-amd64

FROM mysql-57-${TARGETARCH} as mysql-57

FROM mysql:8.0 as mysql-80

FROM mysql:8.1 as mysql-81

FROM mysql-${MYSQL_SHORT_VERSION} as mysql-base

LABEL org.opencontainers.image.authors="Druid.fi" maintainer="Druid.fi"
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
