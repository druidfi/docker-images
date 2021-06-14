variable "REPO" {
  default = "druidfi/drupalx"
}

variable "PHP73_MINOR" {}
variable "PHP74_MINOR" {}
variable "PHP80_MINOR" {}

group "default" {
  targets = ["base-variants", "web-variants"]
}

group "base-variants" {
  targets = ["base-7.3", "base-7.4", "base-8.0"]
}

group "web-variants" {
  targets = ["web-7.3", "web-7.4", "web-8.0"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BASE_PHP_IMAGE_NAME = "druidfi/phpx"
    BASE_DRUPAL_IMAGE_NAME = "${REPO}"
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
  tags = ["${REPO}:7.3", "${REPO}:${PHP73_MINOR}", "${REPO}:7.3-latest"]
}

target "web-7.3" {
  inherits = ["common", "base-7.3", "web"]
  tags = ["${REPO}:7.3-web", "${REPO}:${PHP73_MINOR}-web", "${REPO}:7.3-web-latest"]
}

target "base-7.4" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "7.4"
    PHP_SHORT_VERSION = "74"
  }
  tags = ["${REPO}:7.4", "${REPO}:${PHP74_MINOR}", "${REPO}:7.4-latest"]
}

target "web-7.4" {
  inherits = ["common", "base-7.4", "web"]
  tags = ["${REPO}:7.4-web", "${REPO}:${PHP74_MINOR}-web", "${REPO}:7.4-web-latest"]
}

target "base-8.0" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "8.0"
    PHP_SHORT_VERSION = "80"
  }
  tags = ["${REPO}:8.0", "${REPO}:${PHP80_MINOR}", "${REPO}:8.0-latest"]
}

target "web-8.0" {
  inherits = ["common", "base-8.0", "web"]
  tags = ["${REPO}:8.0-web", "${REPO}:${PHP80_MINOR}-web", "${REPO}:8.0-web-latest"]
}
