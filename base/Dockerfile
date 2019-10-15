ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="druid.fi"

ARG USER=druid
ARG APP=/app
ARG UID=1000

# Copy configuration files and scripts
COPY files/ /

# Upgrade existing packages
RUN apk update && apk upgrade && \
    #
    # Install bash, git and tini
    #
    apk --update --no-cache add bash git tini && \
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
    # Set directories and permissions
    #
    mkdir -p ${APP} && \
    chown -R ${USER}:${USER} /home/${USER} && \
    chown -R ${USER}:${USER} ${APP} && \
    chmod -R g+rwX ${APP}

WORKDIR ${APP}

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["entrypoint.sh"]
