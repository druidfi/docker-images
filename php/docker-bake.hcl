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

variable "PHP80_MINOR" {}
variable "PHP81_MINOR" {}
variable "PHP82_MINOR" {}

group "default" {
  targets = ["php-variants", "php-fpm-variants", "drupal-fpm-variants", "drupal-web-variants"]
}

group "php-variants" {
  targets = ["php-80", "php-81", "php-82"]
}

group "php-fpm-variants" {
  targets = ["php-fpm-80", "php-fpm-81", "php-fpm-82"]
}

group "php-beta-variants" {
  targets = ["php-82", "php-fpm-82"]
}

group "drupal-fpm-variants" {
  targets = ["drupal-fpm-80", "drupal-fpm-81", "drupal-fpm-82"]
}

group "drupal-web-variants" {
  targets = ["drupal-web-80", "drupal-web-81", "drupal-web-82"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
}

#
# PHP
#

target "php" {
  context = "./php"
  target = "final-php"
}

target "php-80" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "3.16.4"
    PHP_VERSION = "8.0"
    PHP_SHORT_VERSION = "80"
  }
  tags = ["${REPO_BASE}:8.0", "${REPO_BASE}:${PHP80_MINOR}"]
}

target "php-81" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "3.17.3"
    PHP_VERSION = "8.1"
    PHP_SHORT_VERSION = "81"
  }
  tags = ["${REPO_BASE}:8", "${REPO_BASE}:8.1", "${REPO_BASE}:${PHP81_MINOR}", "${REPO_BASE}:latest"]
}

target "php-82" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "3.17.3"
    PHP_VERSION = "8.2"
    PHP_SHORT_VERSION = "82"
  }
  tags = ["${REPO_BASE}:8.2", "${REPO_BASE}:${PHP82_MINOR}"]
}

#
# PHP-FPM
#

target "php-fpm" {
  context = "./php"
  target = "final-php-fpm"
}

target "php-fpm-80" {
  inherits = ["common", "php-80", "php-fpm"]
  tags = ["${REPO_FPM}:8.0", "${REPO_FPM}:${PHP80_MINOR}"]
}

target "php-fpm-81" {
  inherits = ["common", "php-81", "php-fpm"]
  tags = ["${REPO_FPM}:8", "${REPO_FPM}:8.1", "${REPO_FPM}:${PHP81_MINOR}", "${REPO_FPM}:latest"]
}

target "php-fpm-82" {
  inherits = ["common", "php-82", "php-fpm"]
  tags = ["${REPO_FPM}:8.2", "${REPO_FPM}:${PHP82_MINOR}"]
}

#
# Drupal (PHP-FPM)
#

target "drupal-fpm-80" {
  inherits = ["common", "php-80", "php-fpm"]
  target = "drupal-php-80"
  tags = ["${REPO_DRUPAL_FPM}:php-8.0", "${REPO_DRUPAL_FPM}:php-${PHP80_MINOR}"]
}

target "drupal-fpm-81" {
  inherits = ["common", "php-81", "php-fpm"]
  target = "drupal-php-81"
  tags = ["${REPO_DRUPAL_FPM}:php-8", "${REPO_DRUPAL_FPM}:php-8.1", "${REPO_DRUPAL_FPM}:php-${PHP81_MINOR}", "${REPO_DRUPAL_FPM}:latest"]
}

target "drupal-fpm-82" {
  inherits = ["common", "php-82", "php-fpm"]
  target = "drupal-php-82"
  tags = ["${REPO_DRUPAL_FPM}:php-8.2", "${REPO_DRUPAL_FPM}:php-${PHP82_MINOR}"]
}

#
# Drupal (PHP-FPM + Nginx)
#

target "drupal-web-80" {
  inherits = ["common", "php-80", "php-fpm"]
  target = "drupal-web"
  tags = ["${REPO_DRUPAL_WEB}:php-8.0", "${REPO_DRUPAL_WEB}:php-${PHP80_MINOR}"]
}

target "drupal-web-81" {
  inherits = ["common", "php-81", "php-fpm"]
  target = "drupal-web"
  tags = ["${REPO_DRUPAL_WEB}:php-8", "${REPO_DRUPAL_WEB}:php-8.1", "${REPO_DRUPAL_WEB}:php-${PHP81_MINOR}", "${REPO_DRUPAL_WEB}:latest"]
}

target "drupal-web-82" {
  inherits = ["common", "php-82", "php-fpm"]
  target = "drupal-web"
  tags = ["${REPO_DRUPAL_WEB}:php-8.2", "${REPO_DRUPAL_WEB}:php-${PHP82_MINOR}"]
}
