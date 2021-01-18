ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION

LABEL maintainer="druid.fi"

# All images based on this one will have these ENV vars
ENV KIND=druid-docker-image \
    ALPINE_VERSION=${ALPINE_VERSION} \
    APP_PATH=/app \
    DEFAULT_USER=druid \
    DEFAULT_USER_UID=1000

# Copy configuration files and scripts
COPY files/ /

# See https://docs.microsoft.com/en-us/azure/mysql/howto-configure-ssl
ADD https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt.pem /opt/ssl/

# Upgrade existing packages
RUN apk update && apk upgrade && \
    #
    # Install needed packages
    #
    apk --update --no-cache add bash curl git make nano sudo tini && \
    #
    # Ensure www-data user exists
    #
    addgroup -g 82 -S www-data && \
    adduser -u 82 -D -S -G www-data www-data && \
    #
    # Create user group
    #
    addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID} && \
    #
    # Create user
    #
    # adduser -D = Don't assign password
    # adduser -S = Create a system user
    # adduser -G = Add user to existing group
    # adduser -u = User id
    adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER} && \
    chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER} && \
    #
    # Add user to www-data group
    #
    adduser ${DEFAULT_USER} www-data && \
    #
    # Add user to sudoers
    #
    echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:SETENV:ALL" > /etc/sudoers.d/${DEFAULT_USER} && \
    chmod 0440 /etc/sudoers.d/${DEFAULT_USER} && \
    #
    # Quiet down Sudo
    #
    echo "Set disable_coredump false" > /etc/sudo.conf && \
    #
    # Install envplate
    #
    curl -sLo /bin/ep https://github.com/kreuzwerker/envplate/releases/download/1.0.0-RC1/ep-linux && \
    echo "48e234e067874a57a4d4bb198b5558d483ee37bcc285287fffb3864818b42f2785be0568faacbc054e97ca1c5047ec70382e1ca0e71182c9dba06649ad83a5f6  /bin/ep" | sha512sum -c && \
    chmod +x /bin/ep && \
    #
    # Create app directory
    #
    mkdir -p ${APP_PATH} && \
    chown ${DEFAULT_USER}:${DEFAULT_USER} ${APP_PATH} && \
    #
    # Set permissions
    #
    chmod 0644 /opt/ssl/BaltimoreCyberTrustRoot.crt.pem

USER ${DEFAULT_USER}
WORKDIR ${APP_PATH}

ENTRYPOINT ["/sbin/tini", "--"]

# Default command: Start up multiple services via entrypoint
CMD ["entrypoint"]
