FROM alpine:3.11

LABEL maintainer="druid.fi"

ARG USER=druid
ARG UID=1000

ENV SOCKET_DIR=/tmp/ssh-agent
ENV SSH_AUTH_SOCK=${SOCKET_DIR}/socket
ENV SSH_AUTH_PROXY_SOCK=${SOCKET_DIR}/proxy-socket

RUN apk add --update openssh socat && \
    rm -rf /var/cache/apk/* && \
    mkdir ${SOCKET_DIR} && \
    adduser -D -u ${UID} ${USER} && \
    chown ${USER} ${SOCKET_DIR}

# Copy configuration files and scripts
COPY files/ /

VOLUME ${SOCKET_DIR}

ENTRYPOINT ["run"]

CMD ["ssh-agent"]
