ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION}-alpine

LABEL maintainer="druid.fi"

# Copy configuration files and scripts
COPY files/ /

# Check the configuration
RUN nginx -t
