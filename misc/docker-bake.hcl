variable ALPINE_VERSION {}
variable SIMPLESAMLPHP_VERSION {
  default = "1.19.1"
}

group "default" {
  targets = ["curl", "s3-sync", "saml-idp", "solr", "varnish"]
}

target "common" {
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
  }
  platforms = ["linux/amd64", "linux/arm64"]
}

target "curl" {
  inherits = ["common"]
  context = "./misc/curl"
  tags = ["druidfi/curl:alpine", "druidfi/curl:alpine-${ALPINE_VERSION}", "druidfi/curl:alpine${ALPINE_VERSION}"]
}

target "saml-idp" {
  inherits = ["common"]
  context = "./misc/saml-idp"
  args = {
    SIMPLESAMLPHP_VERSION = "${SIMPLESAMLPHP_VERSION}"
  }
  tags = ["druidfi/saml-idp:${SIMPLESAMLPHP_VERSION}"]
}

target "s3-sync" {
  inherits = ["common"]
  context = "./misc/s3-sync"
  tags = ["druidfi/s3-sync:alpine", "druidfi/s3-sync:alpine-${ALPINE_VERSION}", "druidfi/s3-sync:alpine${ALPINE_VERSION}"]
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
