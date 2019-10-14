ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="druid.fi"

ARG USER=druid
ARG APP=/app
ARG UID=1000

# Set group & user
RUN addgroup -S ${USER} -g ${UID} && adduser -S -G ${USER} -u ${UID} ${USER}

# Upgrade existing packages and install software
RUN apk update && apk upgrade && \
    apk --update --no-cache add git tini

# Set directories and permissions
RUN mkdir -p ${APP} && \
    chown -R ${USER}:${USER} ${APP} && \
    chmod -R g+rwX ${APP}

# Copy configuration files and scripts
COPY files/ /

WORKDIR ${APP}

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["entrypoint.sh"]
