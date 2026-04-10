variable "REPO_BASE" {
  default = "druidfi/frankenphp"
}

variable "REPO_GHCR" {
  default = "ghcr.io/druidfi/frankenphp"
}

variable "FRANKENPHP_VERSION" {
  default = "1.12.2"
}

variable "FRANKENPHP_PHP84" {
  default = "8.4.18"
}

variable "FRANKENPHP_PHP85" {
  default = "8.5.3"
}

group "default" {
  targets = [
    "php-84",
    "php-85",
  ]
}

target "common" {
  context = "./"
  dockerfile = "./frankenphp/Dockerfile"
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
  labels = {
    "org.opencontainers.image.url" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.source" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.licenses" = "MIT"
    "org.opencontainers.image.vendor" = "Druid Oy"
    "org.opencontainers.image.created" = timestamp()
  }
}

#
# FRANKENPHP
#

target "php-84" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.4"
    PHP_SHORT_VERSION = "84"
  }
  contexts = {
    frankenphp_upstream = "docker-image://dunglas/frankenphp:${FRANKENPHP_VERSION}-php${FRANKENPHP_PHP84}"
  }
  tags = [
    "${REPO_BASE}:${FRANKENPHP_VERSION}-php8.4",
    "${REPO_BASE}:${FRANKENPHP_VERSION}-php${FRANKENPHP_PHP84}",
    "${REPO_GHCR}:${FRANKENPHP_VERSION}-php8.4",
    "${REPO_GHCR}:${FRANKENPHP_VERSION}-php${FRANKENPHP_PHP84}",
  ]
}

target "php-85" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.5"
    PHP_SHORT_VERSION = "85"
  }
  contexts = {
    frankenphp_upstream = "docker-image://dunglas/frankenphp:${FRANKENPHP_VERSION}-php${FRANKENPHP_PHP85}"
  }
  tags = [
    "${REPO_BASE}:${FRANKENPHP_VERSION}-php8",
    "${REPO_BASE}:${FRANKENPHP_VERSION}-php8.5",
    "${REPO_BASE}:${FRANKENPHP_VERSION}-php${FRANKENPHP_PHP85}",
    "${REPO_BASE}:latest",
    "${REPO_GHCR}:${FRANKENPHP_VERSION}-php8",
    "${REPO_GHCR}:${FRANKENPHP_VERSION}-php8.5",
    "${REPO_GHCR}:${FRANKENPHP_VERSION}-php${FRANKENPHP_PHP85}",
    "${REPO_GHCR}:latest",
  ]
}
