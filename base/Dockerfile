ARG ALPINE_VERSION

FROM druidfi/base-init:alpine${ALPINE_VERSION}

ARG ALPINE_VERSION

# All images based on this one will have this ENV var
ENV APP_PATH=/app \
    DEFAULT_USER=druid \
    DEFAULT_USER_UID=1000

# Copy configuration files and scripts
COPY files/ /

# Download mhsendmail binary
COPY binaries/mhsendmail_linux_amd64_v0.2.0 /usr/local/bin/mhsendmail

# Upgrade existing packages
RUN apk update && apk upgrade && \
    #
    # Install needed packages
    #
    apk --update --no-cache add bash curl git make nano sudo tini && \
    #
    # Create user group
    #
    addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID} && \
    #
    # Create user
    #
    # adduser -S = Create a system user
    # adduser -G = Add user to existing group
    # adduser -u = User id
    adduser -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} ${DEFAULT_USER} && \
    #
    # Add user to root group
    #
    addgroup ${DEFAULT_USER} root && \
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
    # Create app directory
    #
    mkdir -p ${APP_PATH} && \
    #
    # Set permissions
    #
    fix-permissions ${APP_PATH} && \
    chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER} && \
    chmod +x /usr/local/bin/mhsendmail

USER ${DEFAULT_USER}
WORKDIR ${APP_PATH}

ENTRYPOINT ["/sbin/tini", "--"]

# Default command: Start up multiple services via entrypoint
CMD ["entrypoint"]
