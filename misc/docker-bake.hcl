variable "ALPINE_VERSION" {
  default = "3.21.3"
}

variable SIMPLESAMLPHP_VERSION {
  default = "2.3.7"
}

group "default" {
  targets = ["s3-sync", "saml-idp", "solr"]
}

target "common" {
  debug = true
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
  }
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.url" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.source" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.licenses" = "MIT"
    "org.opencontainers.image.vendor" = "Druid Oy"
    "org.opencontainers.image.created" = "${timestamp()}"
  }
}

target "curl" {
  inherits = ["common"]
  context = "./misc/curl"
  tags = ["druidfi/curl:alpine", "druidfi/curl:alpine-${ALPINE_VERSION}", "druidfi/curl:alpine${ALPINE_VERSION}"]
}

target "saml-idp" {
  inherits = ["common"]
  context = "./misc/saml-idp"
  target = "final"
  args = {
    SIMPLESAMLPHP_VERSION = "${SIMPLESAMLPHP_VERSION}"
  }
  tags = ["druidfi/saml-idp:${SIMPLESAMLPHP_VERSION}"]
}

target "s3-sync" {
  inherits = ["common"]
  context = "./misc/s3-sync"
  tags = ["druidfi/s3-sync:alpine", "druidfi/s3-sync:alpine-${ALPINE_VERSION}", "druidfi/s3-sync:latest"]
}

target "solr" {
  inherits = ["common"]
  context = "./misc/solr"
  target = "solr"
  tags = ["druidfi/solr:9-drupal","druidfi/solr:9.8.1-drupal"]
}

target "solr-8" {
  inherits = ["common"]
  context = "./misc/solr"
  dockerfile = "Dockerfile.8"
  target = "solr8"
  tags = ["druidfi/solr:8-drupal","druidfi/solr:8.11-drupal"]
}

target "varnish" {
  inherits = ["common"]
  context = "./misc/varnish"
  tags = ["druidfi/varnish:6-drupal"]
}
