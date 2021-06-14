variable ALPINE_VERSION {}
variable ALPINE_VERSION_PREVIOUS {}

group "default" {
  targets = ["alpine-current", "alpine-previous"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
}

target "alpine-current" {
  inherits = ["common"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
  }
  tags = ["druidfi/base:alpine${ALPINE_VERSION}", "druidfi/base:alpine-${ALPINE_VERSION}"]
}

target "alpine-previous" {
  inherits = ["common"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION_PREVIOUS}"
  }
  tags = ["druidfi/base:alpine${ALPINE_VERSION_PREVIOUS}", "druidfi/base:alpine-${ALPINE_VERSION_PREVIOUS}"]
}
