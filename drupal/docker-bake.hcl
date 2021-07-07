variable "REPO_BASE" {
  default = "druidfi/drupal"
}

variable "REPO_WEB" {
  default = "druidfi/drupal-web"
}

variable "REPO_TEST" {
  default = "druidfi/drupal-test"
}

variable "PHP73_MINOR" {}
variable "PHP74_MINOR" {}
variable "PHP80_MINOR" {}

group "default" {
  targets = ["base-variants", "web-variants", "test-variants"]
}

group "base-variants" {
  targets = ["base-7.3", "base-7.4", "base-8.0"]
}

group "web-variants" {
  targets = ["web-7.3", "web-7.4", "web-8.0"]
}

group "test-variants" {
  targets = ["test-7.3", "test-7.4", "test-8.0"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BASE_PHP_IMAGE_NAME = "druidfi/php-fpm"
    BASE_DRUPAL_IMAGE_NAME = "${REPO_BASE}"
  }
}

target "base" {
  context = "./base"
}

target "web" {
  context = "./web"
}

target "base-7.3" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "7.3"
    PHP_SHORT_VERSION = "73"
  }
  tags = ["${REPO_BASE}:php-7.3", "${REPO_BASE}:php-${PHP73_MINOR}"]
}

target "base-7.4" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "7.4"
    PHP_SHORT_VERSION = "74"
  }
  tags = ["${REPO_BASE}:php-7", "${REPO_BASE}:php-7.4", "${REPO_BASE}:php-${PHP74_MINOR}", "${REPO_BASE}:latest"]
}

target "base-8.0" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "8.0"
    PHP_SHORT_VERSION = "80"
  }
  tags = ["${REPO_BASE}:php-8", "${REPO_BASE}:php-8.0", "${REPO_BASE}:php-${PHP80_MINOR}"]
}

target "web-7.3" {
  inherits = ["common", "base-7.3", "web"]
  tags = ["${REPO_WEB}:php-7.3", "${REPO_WEB}:php-${PHP73_MINOR}"]
}

target "web-7.4" {
  inherits = ["common", "base-7.4", "web"]
  tags = ["${REPO_WEB}:php-7", "${REPO_WEB}:php-7.4", "${REPO_WEB}:php-${PHP74_MINOR}", "${REPO_WEB}:latest"]
}

target "web-8.0" {
  inherits = ["common", "base-8.0", "web"]
  tags = ["${REPO_WEB}:php-8", "${REPO_WEB}:php-8.0", "${REPO_WEB}:php-${PHP80_MINOR}"]
}

target "test" {
  context = "./test"
}

target "test-7.3" {
  inherits = ["common", "base-7.3", "test"]
  tags = ["${REPO_TEST}:php-7.3"]
}

target "test-7.4" {
  inherits = ["common", "base-7.4", "test"]
  tags = ["${REPO_TEST}:php-7.4"]
}

target "test-8.0" {
  inherits = ["common", "base-8.0", "test"]
  tags = ["${REPO_TEST}:php-8.0"]
}
