ARG MYSQL_VERSION

FROM mysql:${MYSQL_VERSION}

LABEL maintainer="druid.fi"

ENV MYSQL_DATABASE=drupal \
    MYSQL_USER=drupal \
    MYSQL_PASSWORD=drupal \
    MYSQL_ROOT_PASSWORD=drupal

RUN printf '[mysqld]\nmax_allowed_packet=16M' >> /etc/mysql/conf.d/drupal.cnf
