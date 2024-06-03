# syntax=docker/dockerfile:1.6

ARG MYSQL_SHORT_VERSION

FROM --platform=linux/arm64 biarms/mysql:5.7 as mysql-57-arm64
FROM --platform=linux/amd64 mysql:5.7 as mysql-57-amd64

FROM mysql-57-${TARGETARCH} as mysql-57

FROM mysql:8.0 as mysql-80

FROM mysql:8.4 as mysql-84

FROM mysql-${MYSQL_SHORT_VERSION} as mysql-base

ARG DRUPAL_CONF="/etc/mysql/conf.d/drupal.cnf"

ENV KIND=druid-docker-image \
    MYSQL_DATABASE=drupal \
    MYSQL_USER=drupal \
    MYSQL_PASSWORD=drupal \
    MYSQL_ROOT_PASSWORD=drupal

RUN <<EOF
printf '[mysqld]\nmax_allowed_packet=16M' >> ${DRUPAL_CONF}
cat ${DRUPAL_CONF}
EOF
