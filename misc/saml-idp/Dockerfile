FROM php:7.4-apache

ARG SIMPLESAMLPHP_VERSION=1.18.5
ARG SIMPLESAMLPHP_URL=https://github.com/simplesamlphp/simplesamlphp/releases/download/v${SIMPLESAMLPHP_VERSION}/simplesamlphp-${SIMPLESAMLPHP_VERSION}.tar.gz

LABEL maintainer="druid.fi"

# Utilities
RUN apt-get update && \
    apt-get -y install apt-transport-https git curl vim --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# SimpleSAMLphp
RUN curl -s -L -o /tmp/simplesamlphp.tar.gz ${SIMPLESAMLPHP_URL} && \
    tar xzf /tmp/simplesamlphp.tar.gz -C /tmp && \
    rm -f /tmp/simplesamlphp.tar.gz  && \
    mv /tmp/simplesamlphp-* /var/www/simplesamlphp && \
    touch /var/www/simplesamlphp/modules/exampleauth/enable

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
