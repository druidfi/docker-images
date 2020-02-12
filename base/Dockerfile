ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="druid.fi"

ARG USER=druid
ARG APP=/app
ARG UID=1000

# All images based on this one will have this ENV var
ENV KIND=druid-docker-image

# Copy configuration files and scripts
COPY files/ /

# Upgrade existing packages
RUN apk update && apk upgrade && \
    #
    # Install bash, curl, git, make, nano and tini
    #
    apk --update --no-cache add bash curl git make nano tini && \
    #
    # Create user group
    #
    addgroup -S ${USER} -g ${UID} && \
    #
    # Create user
    #
    # adduser -S = Create a system user
    # adduser -G = Add user to existing group
    # adduser -u = User id
    adduser -S -G ${USER} -u ${UID} ${USER} && \
    #
    # Add user to root group
    #
    addgroup ${USER} root && \
    #
    # Create app directory
    #
    mkdir -p ${APP} && \
    #
    # Set permissions
    #
    fix-permissions ${APP} && \
    chown -R ${USER}:${USER} /home/${USER}

WORKDIR ${APP}

ENTRYPOINT ["/sbin/tini", "--"]

# Default command: Start up multiple services via entrypoint
CMD ["entrypoint"]
