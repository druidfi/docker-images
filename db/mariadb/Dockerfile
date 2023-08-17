ARG MARIADB_VERSION

FROM mariadb:${MARIADB_VERSION} as base

ENV KIND=druid-docker-image \
    MYSQL_DATABASE=drupal \
    MYSQL_USER=drupal \
    MYSQL_PASSWORD=drupal \
    MYSQL_ROOT_PASSWORD=drupal
