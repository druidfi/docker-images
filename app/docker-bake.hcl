variable "REPO_BASE" {
  default = "druidfi/app"
}

variable "PHP81_MINOR" {}
variable "PHP82_MINOR" {}
variable "PHP83_MINOR" {}

group "default" {
  targets = ["php-81", "php-82", "php-83"]
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

target "php-81" {
  inherits = ["common", "php"]
  args = {
    PHP_VERSION = "8.1"
    PHP_SHORT_VERSION = "81"
  }
  contexts = {
    php-base = "docker-image://php:8.1-fpm-alpine"
  }
  labels = {
    "org.opencontainers.image.title" = "Druid App image with PHP 8.1"
    "org.opencontainers.image.description" = "Base PHP 8.1 image"
    #"org.opencontainers.image.version" = VERSION
    #"org.opencontainers.image.revision" = SHA
  }
  tags = ["${REPO_BASE}:php-8.1"]
}

target "php-82" {
  inherits = ["common", "php"]
  args = {
    PHP_VERSION = "8.2"
    PHP_SHORT_VERSION = "82"
  }
  contexts = {
    php-base = "docker-image://php:8.2-fpm-alpine"
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
    php-base = "docker-image://php:8.3-rc-fpm-alpine"
  }
  labels = {
    "org.opencontainers.image.title" = "Druid App image with PHP 8.3"
    "org.opencontainers.image.description" = "Base PHP 8.3 image"
    #"org.opencontainers.image.version" = VERSION
    #"org.opencontainers.image.revision" = SHA
  }
  tags = ["${REPO_BASE}:php-8.3"]
}
