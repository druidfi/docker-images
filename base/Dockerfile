ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="druid.fi"

ARG USER=druid
ARG APP=/app
ARG UID=1000

# Set group & user
RUN addgroup -S ${USER} -g ${UID} && adduser -S -G ${USER} -u ${UID} ${USER}

# Set directories and permissions
RUN mkdir -p ${APP} && \
    chown -R ${USER}:${USER} ${APP} && \
    chmod -R g+rwX ${APP}

WORKDIR ${APP}
