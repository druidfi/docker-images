# syntax=docker/dockerfile:1.4

FROM php-fpm-base as symfony-fpm

RUN echo "DEBUG symfony-fpm"
RUN php -v

FROM symfony-fpm as symfony-web

RUN echo "DEBUG symfony-web"
RUN php -v
