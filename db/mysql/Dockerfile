ARG MYSQL_VERSION

FROM mysql:${MYSQL_VERSION}

LABEL maintainer="druid.fi"

ARG DRUPAL_CONF="/etc/mysql/conf.d/drupal.cnf"

ENV MYSQL_DATABASE=drupal \
    MYSQL_USER=drupal \
    MYSQL_PASSWORD=drupal \
    MYSQL_ROOT_PASSWORD=drupal

RUN printf '[mysqld]\nmax_allowed_packet=16M' >> ${DRUPAL_CONF}

RUN if [ "$MYSQL_MAJOR" = "8.0" ] ; then printf '\ndefault-authentication-plugin=mysql_native_password' >> ${DRUPAL_CONF} ; fi

RUN cat ${DRUPAL_CONF}
