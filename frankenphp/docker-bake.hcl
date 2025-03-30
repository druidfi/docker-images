variable "FRANKENPHP_VERSION" {
  default = "1.5.0"
}

variable "REPO_BASE" {
  default = "druidfi/frankenphp"
}

variable "PHP83_PATCH" {}
variable "PHP84_PATCH" {}

group "default" {
  targets = ["php-variants"]
}

group "php-variants" {
  targets = ["php-83", "php-84"]
}

target "common" {
  context = "./frankenphp"
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    FRANKENPHP_VERSION = "${FRANKENPHP_VERSION}"
  }
  labels = {
    "org.opencontainers.image.url" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.source" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.licenses" = "MIT"
    "org.opencontainers.image.vendor" = "Druid Oy"
    "org.opencontainers.image.created" = "${timestamp()}"
  }
}

#
# FRANKENPHP
#

target "php-83" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.3"
    PHP_SHORT_VERSION = "83"
  }
  contexts = {
    frankenphp_upstream = "docker-image://dunglas/frankenphp:${FRANKENPHP_VERSION}-php${PHP83_PATCH}"
  }
  tags = [
    "${REPO_BASE}:${FRANKENPHP_VERSION}-php8.3",
    "${REPO_BASE}:${FRANKENPHP_VERSION}-php${PHP83_PATCH}"
  ]
}

target "php-84" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.4"
    PHP_SHORT_VERSION = "84"
  }
  contexts = {
    frankenphp_upstream = "docker-image://dunglas/frankenphp:${FRANKENPHP_VERSION}-php${PHP84_PATCH}"
  }
  tags = [
    "${REPO_BASE}:${FRANKENPHP_VERSION}-php8",
    "${REPO_BASE}:${FRANKENPHP_VERSION}-php8.4",
    "${REPO_BASE}:${FRANKENPHP_VERSION}-php${PHP84_PATCH}",
    "${REPO_BASE}:latest"
  ]
}
