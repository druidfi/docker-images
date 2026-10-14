variable "ALPINE_VERSION" {
  default = "3.24.2"
}

variable SIMPLESAMLPHP_VERSION {
  default = "2.5.3.1"
}

group "default" {
  #targets = ["curl", "s3-sync", "saml-idp", "solr"]
  targets = ["s3-sync", "saml-idp", "solr"]
  #targets = ["saml-idp"]
}

target "common" {
  debug = true
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.url" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.source" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.licenses" = "MIT"
    "org.opencontainers.image.vendor" = "Druid Oy"
    "org.opencontainers.image.created" = timestamp()
  }
}

target "curl" {
  inherits = ["common"]
  context = "./misc/curl"
  args = {
    ALPINE_VERSION = ALPINE_VERSION
  }
  tags = ["ghcr.io/druidfi/curl:alpine", "ghcr.io/druidfi/curl:alpine-${ALPINE_VERSION}", "ghcr.io/druidfi/curl:alpine${ALPINE_VERSION}"]
}

target "saml-idp" {
  inherits = ["common"]
  context = "./misc/saml-idp"
  target = "final"
  args = {
    ALPINE_VERSION = ALPINE_VERSION
    SIMPLESAMLPHP_VERSION = SIMPLESAMLPHP_VERSION
  }
  tags = ["ghcr.io/druidfi/saml-idp:${SIMPLESAMLPHP_VERSION}"]
}

target "s3-sync" {
  inherits = ["common"]
  context = "./misc/s3-sync"
  args = {
    ALPINE_VERSION = ALPINE_VERSION
  }
  tags = ["ghcr.io/druidfi/s3-sync:alpine", "ghcr.io/druidfi/s3-sync:alpine-${ALPINE_VERSION}", "ghcr.io/druidfi/s3-sync:latest"]
}

target "solr" {
  inherits = ["common"]
  context = "./misc/solr"
  args = {
    ALPINE_VERSION = ALPINE_VERSION
  }
  target = "solr"
  tags = ["ghcr.io/druidfi/solr:8-drupal","ghcr.io/druidfi/solr:8.11-drupal"]
}

target "claude" {
  inherits = ["common"]
  context = "./misc/claude"
  tags = ["ghcr.io/druidfi/claude:latest"]
}
