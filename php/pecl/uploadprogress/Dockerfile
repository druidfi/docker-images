ARG ALPINE_VERSION
ARG PHP_SHORT_VERSION

FROM alpine:${ALPINE_VERSION} as build

RUN apk add --update --no-cache g++ gcc make git

FROM build as build-php-73

RUN apk add --update --no-cache php7-dev php7-openssl php7-pear

FROM build as build-php-74

RUN apk add --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    php7-dev php7-openssl php7-pear

FROM build-php-${PHP_SHORT_VERSION} as final

RUN php -v
RUN pecl channel-update pecl.php.net
RUN pecl install -f uploadprogress
RUN chmod 0755 /usr/lib/php7/modules/uploadprogress.so

FROM scratch

LABEL maintainer="info@druid.fi"

COPY --from=final /usr/lib/php7/modules/uploadprogress.so /uploadprogress.so

#
# Use this examples:
#
# COPY --from=druidfi/php-pecl-uploadprogress:7.3 /uploadprogress.so /usr/lib/php7/modules/uploadprogress.so
# COPY --from=druidfi/php-pecl-uploadprogress:7.4 /uploadprogress.so /usr/lib/php7/modules/uploadprogress.so
#
