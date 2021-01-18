ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="druid.fi"

ARG USER=druid
ARG UID=1000

ENV SOCKET_DIR=/tmp/${USER}_ssh-agent
ENV SSH_AUTH_SOCK=${SOCKET_DIR}/socket
ENV SSH_AUTH_PROXY_SOCK=${SOCKET_DIR}/proxy-socket

RUN apk --update --no-cache add openssh socat && \
    rm -rf /var/cache/apk/* && \
    adduser -D -u ${UID} ${USER} && \
    mkdir ${SOCKET_DIR} && chown ${USER} ${SOCKET_DIR}

# Copy configuration files and scripts
COPY files/ /

VOLUME ${SOCKET_DIR}

USER ${UID}

ENTRYPOINT ["run"]

CMD ["ssh-agent"]
