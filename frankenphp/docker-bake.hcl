variable "REPO_BASE" {
  default = "druidfi/frankenphp"
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
    frankenphp_upstream = "docker-image://dunglas/frankenphp:1.11.2-php8.4.17"
  }
  tags = [
    "${REPO_BASE}:1.11.2-php8.4",
    "${REPO_BASE}:1.11.2-php8.4.17",
  ]
}

target "php-85" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.5"
    PHP_SHORT_VERSION = "85"
  }
  contexts = {
    frankenphp_upstream = "docker-image://dunglas/frankenphp:1.11.2-php8.5.2"
  }
  tags = [
    "${REPO_BASE}:1.11.2-php8",
    "${REPO_BASE}:1.11.2-php8.5",
    "${REPO_BASE}:1.11.2-php8.5.2",
    "${REPO_BASE}:latest",
  ]
}
