#syntax=docker/dockerfile:1

#
# Mautic whitelabeler
#
FROM alpine AS whitelabeler

WORKDIR /app

ADD https://github.com/nickian/mautic-whitelabeler/archive/refs/tags/2.4.3.tar.gz .

RUN tar --strip-components=1 -zxf 2.4.3.tar.gz -C .
RUN ls -lah && exit 1

# Base Mautic image
FROM mautic_upstream AS mautic_base
