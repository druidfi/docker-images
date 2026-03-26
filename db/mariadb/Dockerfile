# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

ARG MARIADB_VERSION=10.11

FROM mariadb:${MARIADB_VERSION} AS base

ARG DRUPAL_CONF="/etc/mysql/conf.d/drupal.cnf"

ENV KIND=druid-docker-image \
    MYSQL_DATABASE=drupal \
    MYSQL_USER=drupal \
    MYSQL_PASSWORD=drupal \
    MYSQL_ROOT_PASSWORD=drupal

RUN <<EOF
printf '[mysqld]\nmax_allowed_packet=64M' >> ${DRUPAL_CONF}
cat ${DRUPAL_CONF}
EOF
