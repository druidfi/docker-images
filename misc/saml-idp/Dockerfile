# syntax=docker/dockerfile:1

FROM alpine AS simplesamlphp

ARG SIMPLESAMLPHP_VERSION
ARG SIMPLESAMLPHP_URL=https://github.com/simplesamlphp/simplesamlphp/releases/download/v${SIMPLESAMLPHP_VERSION}/simplesamlphp-${SIMPLESAMLPHP_VERSION}-slim.tar.gz

RUN apk --update --no-cache add curl
RUN curl -s -L -o /tmp/simplesamlphp.tar.gz ${SIMPLESAMLPHP_URL}
RUN tar xzf /tmp/simplesamlphp.tar.gz -C /tmp
RUN mv /tmp/simplesamlphp-* /home/simplesamlphp
RUN rm -rf /home/simplesamlphp/modules/cron /home/simplesamlphp/modules/multiauth

FROM druidfi/php-fpm:8.4 AS final

USER root

RUN apk --update --no-cache add nginx && \
    apk --update --no-cache add php83-intl php83-tokenizer php83-xmlreader

# Copy SimpleSAMLphp
COPY --from=simplesamlphp --chown=www-data /home/simplesamlphp /app/simplesamlphp

# Copy configuration files and scripts
COPY --chown=www-data files/ /

USER druid

EXPOSE 8080

CMD ["sudo", "nginx"]
