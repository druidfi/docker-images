variable ALPINE_VERSION {}
variable MAILHOG_VERSION {
  default = "1.0.1"
}
variable SIMPLESAMLPHP_VERSION {
  default = "1.19.1"
}

group "default" {
  targets = ["curl", "mailhog", "s3-sync", "saml-idp", "solr", "ssh-agent", "varnish"]
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

target "mailhog" {
  inherits = ["common"]
  context = "./misc/mailhog"
  args = {
    MAILHOG_VERSION = "${MAILHOG_VERSION}"
  }
  tags = [
    "druidfi/mailhog:latest",
    "druidfi/mailhog:1",
    "druidfi/mailhog:${MAILHOG_VERSION}"
  ]
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

target "ssh-agent" {
  inherits = ["common"]
  context = "./misc/ssh-agent"
  tags = ["druidfi/ssh-agent:alpine", "druidfi/ssh-agent:alpine-${ALPINE_VERSION}", "druidfi/ssh-agent:alpine${ALPINE_VERSION}"]
}

target "varnish" {
  inherits = ["common"]
  context = "./misc/varnish"
  tags = ["druidfi/varnish:6-drupal"]
}
