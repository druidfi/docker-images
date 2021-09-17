variable "REPO_BASE" {
  default = "druidfi/php"
}

variable "REPO_FPM" {
  default = "druidfi/php-fpm"
}

variable "REPO_DRUPAL_FPM" {
  default = "druidfi/drupal"
}

variable "ALPINE_VERSION" {}
variable "ALPINE_VERSION_PREVIOUS" {}
variable "PHP73_MINOR" {}
variable "PHP74_MINOR" {}
variable "PHP80_MINOR" {}

group "default" {
  targets = ["php-variants", "php-fpm-variants", "drupal-fpm-variants", "drupal-web-variants"]
}

group "php-variants" {
  targets = ["php-73", "php-74", "php-80"]
}

group "php-fpm-variants" {
  targets = ["php-fpm-73", "php-fpm-74", "php-fpm-80"]
}

group "drupal-fpm-variants" {
  targets = ["drupal-fpm-73", "drupal-fpm-74", "drupal-fpm-80"]
}

group "drupal-web-variants" {
  targets = ["drupal-web-73", "drupal-web-74", "drupal-web-80"]
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

target "php-73" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION_PREVIOUS}"
    PHP_VERSION = "7.3"
    PHP_SHORT_VERSION = "73"
  }
  tags = ["${REPO_BASE}:7.3", "${REPO_BASE}:${PHP73_MINOR}"]
}

target "php-74" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
    PHP_VERSION = "7.4"
    PHP_SHORT_VERSION = "74"
  }
  tags = ["${REPO_BASE}:7", "${REPO_BASE}:7.4", "${REPO_BASE}:${PHP74_MINOR}", "${REPO_BASE}:latest"]
}

target "php-80" {
  inherits = ["common", "php"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
    PHP_VERSION = "8.0"
    PHP_SHORT_VERSION = "80"
  }
  tags = ["${REPO_BASE}:8", "${REPO_BASE}:8.0", "${REPO_BASE}:${PHP80_MINOR}"]
}

#
# PHP-FPM
#

target "php-fpm" {
  context = "./php"
  target = "final-php-fpm"
}

target "php-fpm-73" {
  inherits = ["common", "php-73", "php-fpm"]
  tags = ["${REPO_FPM}:7.3", "${REPO_FPM}:${PHP73_MINOR}"]
}

target "php-fpm-74" {
  inherits = ["common", "php-74", "php-fpm"]
  tags = ["${REPO_FPM}:7", "${REPO_FPM}:7.4", "${REPO_FPM}:${PHP74_MINOR}", "${REPO_FPM}:latest"]
}

target "php-fpm-80" {
  inherits = ["common", "php-80", "php-fpm"]
  tags = ["${REPO_FPM}:8", "${REPO_FPM}:8.0", "${REPO_FPM}:${PHP80_MINOR}"]
}

#
# Drupal (PHP-FPM)
#

target "drupal-fpm-73" {
  inherits = ["common", "php-73", "php-fpm"]
  target = "drupal-73"
  tags = ["${REPO_DRUPAL_FPM}:php-7.3", "${REPO_DRUPAL_FPM}:php-${PHP73_MINOR}"]
}

target "drupal-fpm-74" {
  inherits = ["common", "php-74", "php-fpm"]
  target = "drupal-74"
  tags = ["${REPO_DRUPAL_FPM}:php-7.4", "${REPO_DRUPAL_FPM}:php-${PHP74_MINOR}", "${REPO_DRUPAL_FPM}:latest"]
}

target "drupal-fpm-80" {
  inherits = ["common", "php-80", "php-fpm"]
  target = "drupal-80"
  tags = ["${REPO_DRUPAL_FPM}:php-8.0", "${REPO_DRUPAL_FPM}:php-${PHP80_MINOR}"]
}

#
# Drupal (PHP-FPM + Nginx)
#

target "drupal-web-73" {
  inherits = ["common", "php-73", "php-fpm"]
  target = "drupal-web"
  tags = ["${REPO_DRUPAL_FPM}-web:php-7.3", "${REPO_DRUPAL_FPM}-web:php-${PHP73_MINOR}"]
}

target "drupal-web-74" {
  inherits = ["common", "php-74", "php-fpm"]
  target = "drupal-web"
  tags = ["${REPO_DRUPAL_FPM}-web:php-7.4", "${REPO_DRUPAL_FPM}-web:php-${PHP74_MINOR}", "${REPO_DRUPAL_FPM}-web:latest"]
}

target "drupal-web-80" {
  inherits = ["common", "php-80", "php-fpm"]
  target = "drupal-web"
  tags = ["${REPO_DRUPAL_FPM}-web:php-8.0", "${REPO_DRUPAL_FPM}-web:php-${PHP80_MINOR}"]
}
