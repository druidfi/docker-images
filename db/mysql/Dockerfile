# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

ARG MYSQL_SHORT_VERSION=80

FROM mysql:8.0 AS mysql-80
FROM mysql:8.4 AS mysql-84
FROM mysql:9.7 AS mysql-97

FROM mysql-${MYSQL_SHORT_VERSION} AS mysql-base

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
