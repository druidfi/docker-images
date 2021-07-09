variable "REPO_BASE" {
  default = "druidfi/php"
}

variable "REPO_FPM" {
  default = "druidfi/php-fpm"
}

variable "ALPINE_VERSION" {}
variable "ALPINE_VERSION_PREVIOUS" {}
variable "PHP73_MINOR" {}
variable "PHP74_MINOR" {}
variable "PHP80_MINOR" {}

group "default" {
  targets = ["base-variants", "fpm-variants"]
}

group "base-variants" {
  targets = ["base-73", "base-74", "base-80"]
}

group "fpm-variants" {
  targets = ["fpm-73", "fpm-74", "fpm-80"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
}

target "base" {
  context = "./base"
}

target "base-73" {
  inherits = ["common", "base"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION_PREVIOUS}"
    PHP_VERSION = "7.3"
    PHP_SHORT_VERSION = "73"
  }
  tags = ["${REPO_BASE}:7.3", "${REPO_BASE}:${PHP73_MINOR}"]
}

target "base-74" {
  inherits = ["common", "base"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
    PHP_VERSION = "7.4"
    PHP_SHORT_VERSION = "74"
  }
  tags = ["${REPO_BASE}:7", "${REPO_BASE}:7.4", "${REPO_BASE}:${PHP74_MINOR}", "${REPO_BASE}:latest"]
}

target "base-80" {
  inherits = ["common", "base"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
    PHP_VERSION = "8.0"
    PHP_SHORT_VERSION = "80"
  }
  tags = ["${REPO_BASE}:8", "${REPO_BASE}:8.0", "${REPO_BASE}:${PHP80_MINOR}"]
}

target "fpm" {
  context = "./fpm"
  args = {
    BASE_IMAGE_NAME = "${REPO_BASE}"
  }
}

target "fpm-73" {
  inherits = ["common", "base-73", "fpm"]
  tags = ["${REPO_FPM}:7.3", "${REPO_FPM}:${PHP73_MINOR}"]
}

target "fpm-74" {
  inherits = ["common", "base-74", "fpm"]
  tags = ["${REPO_FPM}:7", "${REPO_FPM}:7.4", "${REPO_FPM}:${PHP74_MINOR}", "${REPO_FPM}:latest"]
}

target "fpm-80" {
  inherits = ["common", "base-80", "fpm"]
  tags = ["${REPO_FPM}:8", "${REPO_FPM}:8.0", "${REPO_FPM}:${PHP80_MINOR}"]
}
