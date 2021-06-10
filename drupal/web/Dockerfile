ARG PHP_VERSION

FROM druidfi/drupal:${PHP_VERSION} AS baseline

# Install Nginx
RUN sudo apk --update --no-cache add nginx

# Copy configuration files and scripts
COPY files/entrypoints/* /entrypoints

# Copy Nginx configuration
COPY files/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY files/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Expose port 8080 for Nginx
EXPOSE 8080

# Default command: Start up multiple services via entrypoint
CMD ["entrypoint"]
