variable "ALPINE_VERSION" {
  default = "3.22.2"
}

variable "REPO_BASE" {
  default = "ghcr.io/druidfi/php"
}

variable "REPO_FPM" {
  default = "ghcr.io/druidfi/php-fpm"
}

variable "REPO_DRUPAL_FPM" {
  default = "ghcr.io/druidfi/drupal"
}

variable "REPO_DRUPAL_WEB" {
  default = "ghcr.io/druidfi/drupal-web"
}

variable "PHP83_MINOR" {}
variable "PHP84_MINOR" {}
variable "PHP85_MINOR" {}

group "default" {
  targets = ["php-variants", "php-fpm-variants", "drupal-fpm-variants", "drupal-web-variants"]
}

group "php-variants" {
  targets = ["php-83", "php-84", "php-85"]
}

group "php-fpm-variants" {
  targets = ["php-fpm-83", "php-fpm-84", "php-fpm-85"]
}

group "drupal-fpm-variants" {
  targets = ["drupal-fpm-83", "drupal-fpm-84", "drupal-fpm-85"]
}

group "drupal-web-variants" {
  targets = ["drupal-web-83", "drupal-web-84", "drupal-web-85"]
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
  context = "./php"
  target = "final-php"
}

target "php-83" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
    PHP_VERSION = "8.3"
    PHP_SHORT_VERSION = "83"
  }
  tags = [
    "${REPO_BASE}:8.3",
    "${REPO_BASE}:${PHP83_MINOR}"
  ]
}

target "php-84" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
    PHP_VERSION = "8.4"
    PHP_SHORT_VERSION = "84"
  }
  tags = [
    "${REPO_BASE}:8",
    "${REPO_BASE}:8.4",
    "${REPO_BASE}:${PHP84_MINOR}",
    "${REPO_BASE}:latest"
  ]
}

target "php-85" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
    PHP_VERSION = "8.5"
    PHP_SHORT_VERSION = "85"
  }
  tags = [
    "${REPO_BASE}:8.5",
    "${REPO_BASE}:${PHP85_MINOR}",
  ]
}

#
# PHP-FPM
#

target "php-fpm" {
  context = "./php"
  target = "final-php-fpm"
}

target "php-fpm-83" {
  inherits = ["common", "php-83", "php-fpm"]
  tags = [
    "${REPO_FPM}:8.3",
    "${REPO_FPM}:${PHP83_MINOR}"
  ]
}

target "php-fpm-84" {
  inherits = ["common", "php-84", "php-fpm"]
  tags = [
    "${REPO_FPM}:8",
    "${REPO_FPM}:8.4",
    "${REPO_FPM}:${PHP84_MINOR}",
    "${REPO_FPM}:latest"
  ]
}

target "php-fpm-85" {
  inherits = ["common", "php-85", "php-fpm"]
  tags = [
    "${REPO_FPM}:8.5",
    "${REPO_FPM}:${PHP85_MINOR}"
  ]
}

#
# Drupal (PHP-FPM)
#

target "drupal-fpm-83" {
  inherits = ["common", "php-83", "php-fpm"]
  target = "drupal-php-83"
  tags = [
    "${REPO_DRUPAL_FPM}:php-8.3",
    "${REPO_DRUPAL_FPM}:php-${PHP83_MINOR}"
  ]
}

target "drupal-fpm-84" {
  inherits = ["common", "php-84", "php-fpm"]
  target = "drupal-php-84"
  tags = [
    "${REPO_DRUPAL_FPM}:php-8",
    "${REPO_DRUPAL_FPM}:php-8.4",
    "${REPO_DRUPAL_FPM}:php-${PHP84_MINOR}",
    "${REPO_DRUPAL_FPM}:latest"
  ]
}

target "drupal-fpm-85" {
  inherits = ["common", "php-85", "php-fpm"]
  target = "drupal-php-85"
  tags = [
    "${REPO_DRUPAL_FPM}:php-8.5",
    "${REPO_DRUPAL_FPM}:php-${PHP85_MINOR}"
  ]
}

#
# Drupal (PHP-FPM + Nginx)
#

target "drupal-web-83" {
  inherits = ["common", "php-83", "php-fpm"]
  target = "drupal-web"
  tags = [
    "${REPO_DRUPAL_WEB}:php-8.3",
    "${REPO_DRUPAL_WEB}:php-${PHP83_MINOR}",
  ]
}

target "drupal-web-84" {
  inherits = ["common", "php-84", "php-fpm"]
  target = "drupal-web"
  tags = [
    "${REPO_DRUPAL_WEB}:php-8",
    "${REPO_DRUPAL_WEB}:php-8.4",
    "${REPO_DRUPAL_WEB}:php-${PHP84_MINOR}",
    "${REPO_DRUPAL_WEB}:latest",
  ]
}

target "drupal-web-85" {
  inherits = ["common", "php-85", "php-fpm"]
  target = "drupal-web"
  tags = [
    "${REPO_DRUPAL_WEB}:php-8.5",
    "${REPO_DRUPAL_WEB}:php-${PHP85_MINOR}",
  ]
}
