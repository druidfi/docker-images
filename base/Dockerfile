# syntax=docker/dockerfile:1.3-labs

ARG ALPINE_VERSION

FROM golang:alpine3.14 AS bin-builder

RUN <<EOF
GIT_TAG=github.com/kreuzwerker/envplate@1.0.0-RC1 GIT_COMMIT=977cb694fd31dd89e9326fe4c85572a147011c8f;
go get -ldflags "-X=main.build=$GIT_COMMIT -X=main.version=$GIT_TAG" github.com/kreuzwerker/envplate@$GIT_COMMIT
cd /go/pkg/mod/github.com/kreuzwerker/envplate*
go mod init github.com/kreuzwerker/envplate
go install -mod=mod ./bin/ep.go
EOF

FROM alpine:${ALPINE_VERSION} as base

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

# Copy envplate binary
COPY --from=bin-builder /go/bin/ep /bin/ep

RUN <<EOF
# Upgrade existing packages
apk update && apk upgrade
#
# Install needed packages
#
apk --update --no-cache add bash curl git make nano neofetch sudo tini
#
# Run neofetch to create conf
#
neofetch &&
# Ensure www-data user exists
#
addgroup -g 82 -S www-data || echo "www-data group already exists"
adduser -u 82 -D -S -G www-data www-data
#
# Create user group
#
addgroup -S ${DEFAULT_USER} -g ${DEFAULT_USER_UID}
#
# Create user
#
# adduser -D = Don't assign password
# adduser -S = Create a system user
# adduser -G = Add user to existing group
# adduser -u = User id
adduser -D -S -G ${DEFAULT_USER} -u ${DEFAULT_USER_UID} -s /bin/bash ${DEFAULT_USER}
chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}
#
# Add user to www-data group
#
adduser ${DEFAULT_USER} www-data
#
# Add user to sudoers
#
echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:SETENV:ALL" > /etc/sudoers.d/${DEFAULT_USER}
chmod 0440 /etc/sudoers.d/${DEFAULT_USER}
#
# Quiet down Sudo
#
echo "Set disable_coredump false" > /etc/sudo.conf
#
# Create app directory
#
mkdir -p ${APP_PATH}
chown ${DEFAULT_USER}:${DEFAULT_USER} ${APP_PATH}
#
# Set permissions
#
chmod 0644 /opt/ssl/BaltimoreCyberTrustRoot.crt.pem
EOF

USER ${DEFAULT_USER}
WORKDIR ${APP_PATH}

ENTRYPOINT ["/sbin/tini", "--"]

# Default command: Start up multiple services via entrypoint
CMD ["entrypoint"]
