variable ALPINE_VERSION {}
variable SIMPLESAMLPHP_VERSION {
  default = "2.2.1"
}

group "default" {
  targets = ["curl", "s3-sync", "saml-idp", "solr", "varnish"]
}

target "common" {
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
  tags = ["druidfi/solr:8-drupal","druidfi/solr:8.11-drupal"]
}

target "varnish" {
  inherits = ["common"]
  context = "./misc/varnish"
  tags = ["druidfi/varnish:6-drupal"]
}
