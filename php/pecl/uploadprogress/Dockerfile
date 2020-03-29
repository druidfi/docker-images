ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} as build

RUN apk add --update --no-cache g++ gcc make git php7-dev php7-openssl php7-pear
RUN php -v
RUN pecl channel-update pecl.php.net
RUN pecl install -f uploadprogress
RUN chmod 0755 /usr/lib/php7/modules/uploadprogress.so

FROM scratch

LABEL maintainer="info@druid.fi"

COPY --from=build /usr/lib/php7/modules/uploadprogress.so /uploadprogress.so

#
# Use this examples:
#
# COPY --from=druidfi/php-pecl-uploadprogress:7.1 /uploadprogress.so /usr/lib/php7/modules/uploadprogress.so
# COPY --from=druidfi/php-pecl-uploadprogress:7.3 /uploadprogress.so /usr/lib/php7/modules/uploadprogress.so
#
