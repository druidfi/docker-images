variable "REPO_BASE" {
  default = "druidfi/app"
}

variable "PHP82_MINOR" {}
variable "PHP83_MINOR" {}
variable "PHP84_MINOR" {}

group "default" {
  targets = ["php-82", "php-83"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.url" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.source" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.licenses" = "MIT"
    "org.opencontainers.image.vendor" = "Druid Oy"
    "org.opencontainers.image.created" = "${timestamp()}"
  }
}

#
# PHP
#

target "php" {
  context = "./app"
}

target "php-82" {
  inherits = ["common", "php"]
  args = {
    PHP_VERSION = "8.2"
    PHP_SHORT_VERSION = "82"
  }
  contexts = {
    php-base = "docker-image://php:${PHP82_MINOR}-fpm-alpine"
  }
  labels = {
    "org.opencontainers.image.title" = "Druid App image with PHP 8.2"
    "org.opencontainers.image.description" = "Base PHP 8.2 image"
    #"org.opencontainers.image.version" = VERSION
    #"org.opencontainers.image.revision" = SHA
  }
  tags = ["${REPO_BASE}:php-8", "${REPO_BASE}:php-8.2", "${REPO_BASE}:latest"]
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
    #"org.opencontainers.image.version" = VERSION
    #"org.opencontainers.image.revision" = SHA
  }
  tags = ["${REPO_BASE}:php-8.3"]
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
    #"org.opencontainers.image.version" = VERSION
    #"org.opencontainers.image.revision" = SHA
  }
  tags = ["${REPO_BASE}:php-8.4"]
}
