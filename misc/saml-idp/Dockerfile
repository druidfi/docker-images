FROM alpine as base

ARG SIMPLESAMLPHP_VERSION=1.19.1
ARG SIMPLESAMLPHP_URL=https://github.com/simplesamlphp/simplesamlphp/releases/download/v${SIMPLESAMLPHP_VERSION}/simplesamlphp-${SIMPLESAMLPHP_VERSION}.tar.gz

RUN apk add curl
RUN curl -s -L -o /tmp/simplesamlphp.tar.gz ${SIMPLESAMLPHP_URL}
RUN tar xzf /tmp/simplesamlphp.tar.gz -C /tmp
RUN mv /tmp/simplesamlphp-* /home/simplesamlphp
RUN touch /home/simplesamlphp/modules/exampleauth/enable

FROM php:7.4-apache as final

LABEL maintainer="druid.fi"

# Copy SimpleSAMLphp
COPY --from=base /home/simplesamlphp /var/www/simplesamlphp

# Copy configuration files and scripts
COPY files/ /

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod ssl && \
    # Disable default vhosts(s)
    a2dissite 000-default.conf default-ssl.conf && \
    # Enable SimpleSAMLphp vhost
    a2ensite simplesamlphp.conf

# Set work dir
WORKDIR /var/www/simplesamlphp

# General setup
EXPOSE 8080 8443
