ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} as simplesamlphp

ARG SIMPLESAMLPHP_VERSION=2.0.4
ARG SIMPLESAMLPHP_URL=https://github.com/simplesamlphp/simplesamlphp/releases/download/v${SIMPLESAMLPHP_VERSION}/simplesamlphp-${SIMPLESAMLPHP_VERSION}.tar.gz

RUN apk --update --no-cache add curl
RUN curl -s -L -o /tmp/simplesamlphp.tar.gz ${SIMPLESAMLPHP_URL}
RUN tar xzf /tmp/simplesamlphp.tar.gz -C /tmp
RUN mv /tmp/simplesamlphp-* /home/simplesamlphp
RUN rm -rf /home/simplesamlphp/modules/cron /home/simplesamlphp/modules/multiauth

FROM druidfi/php-fpm:8.2 as final

LABEL org.opencontainers.image.authors="Druid.fi" maintainer="Druid.fi"
LABEL org.opencontainers.image.source="https://github.com/druidfi/docker-images" repository="https://github.com/druidfi/docker-images"

USER root

RUN apk --update --no-cache add nginx && \
    apk --update --no-cache add php82-tokenizer php82-xmlreader

USER druid

# Copy SimpleSAMLphp
COPY --from=simplesamlphp /home/simplesamlphp /app/simplesamlphp

# Copy configuration files and scripts
COPY files/ /

EXPOSE 8080

CMD ["sudo", "nginx"]
