variable "REPO_BASE" {
  default = "druidfi/app"
}

variable "PHP83_MINOR" {}
variable "PHP84_MINOR" {}
variable "PHP85_MINOR" {}

group "default" {
  targets = ["php-83", "php-84", "php-85"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.url" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.source" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.licenses" = "MIT"
    "org.opencontainers.image.vendor" = "Druid Oy"
    "org.opencontainers.image.created" = timestamp()
  }
}

#
# PHP
#

target "php" {
  context = "./app"
  args = {
    PHP_MAJOR_VERSION = 8
  }
}

target "php-83" {
  inherits = ["common", "php"]
  args = {
    PHP_VERSION = "8.3"
    PHP_SHORT_VERSION = "83"
  }
  contexts = {
    php-base = "docker-image://php:${PHP83_MINOR}-fpm-alpine"
  }
  labels = {
    "org.opencontainers.image.title" = "Druid App image with PHP 8.3"
    "org.opencontainers.image.description" = "Base PHP 8.3 image"
  }
  tags = [
    "ghcr.io/${REPO_BASE}:php-8.3",
    "ghcr.io/${REPO_BASE}:php-${PHP83_MINOR}",
  ]
}

target "php-84" {
  inherits = ["common", "php"]
  args = {
    PHP_VERSION = "8.4"
    PHP_SHORT_VERSION = "84"
  }
  contexts = {
    php-base = "docker-image://php:${PHP84_MINOR}-fpm-alpine"
  }
  labels = {
    "org.opencontainers.image.title" = "Druid App image with PHP 8.4"
    "org.opencontainers.image.description" = "Base PHP 8.4 image"
  }
  tags = [
    "ghcr.io/${REPO_BASE}:php-8",
    "ghcr.io/${REPO_BASE}:php-8.4",
    "ghcr.io/${REPO_BASE}:php-${PHP84_MINOR}",
    "ghcr.io/${REPO_BASE}:latest",
  ]
}

target "php-85" {
  inherits = ["common", "php"]
  args = {
    PHP_VERSION = "8.5"
    PHP_SHORT_VERSION = "85"
  }
  contexts = {
    php-base = "docker-image://php:${PHP85_MINOR}-fpm-alpine"
  }
  labels = {
    "org.opencontainers.image.title" = "Druid App image with PHP 8.5"
    "org.opencontainers.image.description" = "Base PHP 8.5 image"
  }
  tags = [
    "ghcr.io/${REPO_BASE}:php-8.5",
    "ghcr.io/${REPO_BASE}:php-${PHP85_MINOR}",
  ]
}
