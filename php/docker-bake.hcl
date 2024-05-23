variable "ALPINE_VERSION" {
  default = "3.20.0"
}

variable "REPO_BASE" {
  default = "druidfi/php"
}

variable "REPO_FPM" {
  default = "druidfi/php-fpm"
}

variable "REPO_DRUPAL_FPM" {
  default = "druidfi/drupal"
}

variable "REPO_DRUPAL_WEB" {
  default = "druidfi/drupal-web"
}

variable "PHP81_MINOR" {}
variable "PHP82_MINOR" {}
variable "PHP83_MINOR" {}

group "default" {
  targets = ["php-variants", "php-fpm-variants", "drupal-fpm-variants", "drupal-web-variants"]
}

group "php-variants" {
  targets = ["php-81", "php-82", "php-83"]
}

group "php-fpm-variants" {
  targets = ["php-fpm-81", "php-fpm-82", "php-fpm-83"]
}

group "drupal-fpm-variants" {
  targets = ["drupal-fpm-81", "drupal-fpm-82", "drupal-fpm-83"]
}

group "drupal-web-variants" {
  targets = ["drupal-web-81", "drupal-web-82", "drupal-web-83"]
}

group "php-83" {
  targets = ["php-83", "php-fpm-83", "drupal-fpm-83", "drupal-web-83"]
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

target "php-81" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "3.19.1"
    PHP_VERSION = "8.1"
    PHP_SHORT_VERSION = "81"
  }
  tags = ["${REPO_BASE}:8.1", "${REPO_BASE}:${PHP81_MINOR}"]
}

target "php-82" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
    PHP_VERSION = "8.2"
    PHP_SHORT_VERSION = "82"
  }
  tags = ["${REPO_BASE}:8", "${REPO_BASE}:8.2", "${REPO_BASE}:${PHP82_MINOR}", "${REPO_BASE}:latest"]
}

target "php-83" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
    PHP_VERSION = "8.3"
    PHP_SHORT_VERSION = "83"
  }
  tags = ["${REPO_BASE}:8.3", "${REPO_BASE}:${PHP83_MINOR}"]
}

#
# PHP-FPM
#

target "php-fpm" {
  context = "./php"
  target = "final-php-fpm"
}

target "php-fpm-81" {
  inherits = ["common", "php-81", "php-fpm"]
  tags = ["${REPO_FPM}:8.1", "${REPO_FPM}:${PHP81_MINOR}"]
}

target "php-fpm-82" {
  inherits = ["common", "php-82", "php-fpm"]
  tags = ["${REPO_FPM}:8", "${REPO_FPM}:8.2", "${REPO_FPM}:${PHP82_MINOR}", "${REPO_FPM}:latest"]
}

target "php-fpm-83" {
  inherits = ["common", "php-83", "php-fpm"]
  tags = ["${REPO_FPM}:8.3", "${REPO_FPM}:${PHP83_MINOR}"]
}

#
# Drupal (PHP-FPM)
#

target "drupal-fpm-81" {
  inherits = ["common", "php-81", "php-fpm"]
  target = "drupal-php-81"
  tags = ["${REPO_DRUPAL_FPM}:php-8.1", "${REPO_DRUPAL_FPM}:php-${PHP81_MINOR}"]
}

target "drupal-fpm-82" {
  inherits = ["common", "php-82", "php-fpm"]
  target = "drupal-php-82"
  tags = ["${REPO_DRUPAL_FPM}:php-8", "${REPO_DRUPAL_FPM}:php-8.2", "${REPO_DRUPAL_FPM}:php-${PHP82_MINOR}", "${REPO_DRUPAL_FPM}:latest"]
}

target "drupal-fpm-83" {
  inherits = ["common", "php-83", "php-fpm"]
  target = "drupal-php-83"
  tags = ["${REPO_DRUPAL_FPM}:php-8.3", "${REPO_DRUPAL_FPM}:php-${PHP83_MINOR}"]
}

#
# Drupal (PHP-FPM + Nginx)
#

target "drupal-web-81" {
  inherits = ["common", "php-81", "php-fpm"]
  target = "drupal-web"
  tags = ["${REPO_DRUPAL_WEB}:php-8.1", "${REPO_DRUPAL_WEB}:php-${PHP81_MINOR}", "${REPO_DRUPAL_WEB}:v${PHP81_MINOR}"]
}

target "drupal-web-82" {
  inherits = ["common", "php-82", "php-fpm"]
  target = "drupal-web"
  tags = ["${REPO_DRUPAL_WEB}:php-8", "${REPO_DRUPAL_WEB}:php-8.2", "${REPO_DRUPAL_WEB}:php-${PHP82_MINOR}", "${REPO_DRUPAL_WEB}:v${PHP82_MINOR}", "${REPO_DRUPAL_WEB}:latest"]
}

target "drupal-web-83" {
  inherits = ["common", "php-83", "php-fpm"]
  target = "drupal-web"
  tags = ["${REPO_DRUPAL_WEB}:php-8.3", "${REPO_DRUPAL_WEB}:php-${PHP83_MINOR}", "${REPO_DRUPAL_WEB}:v${PHP83_MINOR}"]
}
