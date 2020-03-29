ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

RUN apk add --update --no-cache g++ gcc make git php7-dev php7-openssl php7-pear
RUN php -v
RUN pecl channel-update pecl.php.net
RUN pecl install -f uploadprogress
RUN chmod 0755 /usr/lib/php7/modules/uploadprogress.so

#
# Use this examples:
#
# COPY --from=druidfi/php-pecl-uploadprogress:alpine3.7 /usr/lib/php7/modules/uploadprogress.so /uploadprogress.so
# COPY --from=druidfi/php-pecl-uploadprogress:alpine3.11 /usr/lib/php7/modules/uploadprogress.so /uploadprogress.so
#
