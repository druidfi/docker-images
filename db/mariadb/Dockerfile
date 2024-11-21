# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

ARG MARIADB_VERSION=10.6

FROM mariadb:${MARIADB_VERSION} AS base

ENV KIND=druid-docker-image \
    MYSQL_DATABASE=drupal \
    MYSQL_USER=drupal \
    MYSQL_PASSWORD=drupal \
    MYSQL_ROOT_PASSWORD=drupal
