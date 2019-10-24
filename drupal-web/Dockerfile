ARG NGINX_VERSION
ARG PHP_VERSION

FROM druidfi/nginx:${NGINX_VERSION} AS nginx
FROM druidfi/drupal:${PHP_VERSION} AS baseline

LABEL maintainer="druid.fi"

# Install Nginx
RUN apk --update --no-cache add nginx

# Copy configuration files and scripts
COPY files/ /

# Copy Nginx configuration
COPY --from=nginx /etc/nginx/nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for Nginx
# E.g. Traefik can automatically use this
EXPOSE 80

ENTRYPOINT ["/sbin/tini", "--"]

# Start up multiple services via entrypoint
CMD ["entrypoint.sh"]
