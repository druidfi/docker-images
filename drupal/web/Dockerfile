ARG NGINX_VERSION
ARG PHP_VERSION

FROM druidfi/nginx:${NGINX_VERSION} AS nginx
FROM druidfi/drupal:${PHP_VERSION} AS baseline

# Install Nginx
RUN sudo apk --update --no-cache add nginx && \
    sudo addgroup ${DEFAULT_USER} nginx && \
    sudo addgroup ${DEFAULT_USER} www-data

# Copy configuration files and scripts
COPY files/ /

# Copy Nginx configuration
COPY --from=nginx /etc/nginx/nginx.conf /etc/nginx/nginx.conf

# Expose port 8080 for Nginx
EXPOSE 8080

# Default command: Start up multiple services via entrypoint
CMD ["entrypoint"]
