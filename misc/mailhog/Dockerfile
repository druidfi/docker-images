FROM golang:alpine as build

ARG MAILHOG_VERSION=1.0.1

WORKDIR /go/src/github.com/mailhog/MailHog

ADD https://github.com/mailhog/MailHog/archive/v${MAILHOG_VERSION}.tar.gz .

RUN tar --strip-components=1 -zxf v${MAILHOG_VERSION}.tar.gz -C .

# Install MailHog as statically compiled binary:
# ldflags explanation (see `go tool link`):
#   -s  disable symbol table
#   -w  disable DWARF generation
RUN GO111MODULE=off CGO_ENABLED=0 go install -ldflags='-s -w'

FROM scratch as base

LABEL org.opencontainers.image.authors="Druid".fi maintainer="Druid.fi"
LABEL org.opencontainers.image.source="https://github.com/druidfi/docker-images" repository="https://github.com/druidfi/docker-images"

# ca-certificates are required for the "release message" feature:
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /go/bin/MailHog /bin/

# Add LICENSE to image
COPY --from=build /go/src/github.com/mailhog/MailHog/LICENSE.md /LICENSE.md

# Avoid permission issues with host mounts by assigning a user/group with
# uid/gid 1000 (usually the ID of the first user account on GNU/Linux):
USER 1000:1000

# Expose the SMTP and HTTP ports used by default by MailHog:
EXPOSE 1025 8025

ENTRYPOINT ["/bin/MailHog"]
