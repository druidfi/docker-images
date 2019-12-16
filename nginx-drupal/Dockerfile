ARG NGINX_VERSION

FROM druidfi/nginx:${NGINX_VERSION}

LABEL maintainer="druid.fi"

# Copy configuration files and scripts
COPY files/ /

# Check the configuration
RUN nginx -t
