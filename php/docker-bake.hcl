variable "REPO" {
  default = "druidfi/phpx"
}

variable "PHP73_MINOR" {}
variable "PHP74_MINOR" {}
variable "PHP80_MINOR" {}

group "default" {
  targets = ["base-73", "fpm-73", "base-74", "fpm-74", "base-80", "fpm-80"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
}

target "base" {
  context = "./base"
}

target "fpm" {
  context = "./fpm"
  args = {
    BASE_IMAGE_NAME = "${REPO}"
  }
}

target "base-73" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "7.3"
    PHP_SHORT_VERSION = "73"
  }
  tags = ["${REPO}:7.3", "${REPO}:${PHP73_MINOR}", "${REPO}:7.3-latest"]
}

target "fpm-73" {
  inherits = ["common", "fpm", "base-73"]
  tags = ["${REPO}:7.3-fpm", "${REPO}:${PHP73_MINOR}-fpm", "${REPO}:7.3-fpm-latest"]
}

target "base-74" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "7.4"
    PHP_SHORT_VERSION = "74"
  }
  tags = ["${REPO}:7.4", "${REPO}:${PHP74_MINOR}", "${REPO}:7.4-latest"]
}

target "fpm-74" {
  inherits = ["common", "fpm", "base-74"]
  tags = ["${REPO}:7.4-fpm", "${REPO}:${PHP74_MINOR}-fpm", "${REPO}:7.4-fpm-latest"]
}

target "base-80" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "8.0"
    PHP_SHORT_VERSION = "80"
  }
  tags = ["${REPO}:8.0", "${REPO}:${PHP80_MINOR}", "${REPO}:8.0-latest"]
}

target "fpm-80" {
  inherits = ["common", "fpm", "base-80"]
  tags = ["${REPO}:8.0-fpm", "${REPO}:${PHP80_MINOR}-fpm", "${REPO}:8.0-fpm-latest"]
}
