variable "REPO" {
  default = "druidfi/phpx"
}

variable "PHP73_MINOR" {
  default = "7.3.27"
}

variable "PHP74_MINOR" {
  default = "7.4.19"
}

variable "PHP80_MINOR" {
  default = "8.0.6"
}

group "default" {
  targets = ["base-7.3", "fpm-7.3", "base-7.4", "fpm-7.4", "base-8.0", "fpm-8.0"]
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
    BASE_IMAGE_NAME = "druidfi/phpx"
  }
}

target "base-7.3" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "7.3"
    PHP_SHORT_VERSION = "73"
  }
  tags = ["${REPO}:7.3", "${REPO}:${PHP73_MINOR}", "${REPO}:7.3-latest"]
}

target "fpm-7.3" {
  inherits = ["common", "fpm", "base-7.3"]
  tags = ["${REPO}:7.3-fpm", "${REPO}:${PHP73_MINOR}-fpm", "${REPO}:7.3-fpm-latest"]
}

target "base-7.4" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "7.4"
    PHP_SHORT_VERSION = "74"
  }
  tags = ["${REPO}:7.4", "${REPO}:${PHP74_MINOR}", "${REPO}:7.4-latest"]
}

target "fpm-7.4" {
  inherits = ["common", "fpm", "base-7.4"]
  tags = ["${REPO}:7.4-fpm", "${REPO}:${PHP74_MINOR}-fpm", "${REPO}:7.4-fpm-latest"]
}

target "base-8.0" {
  inherits = ["common", "base"]
  args = {
    PHP_VERSION = "8.0"
    PHP_SHORT_VERSION = "80"
  }
  tags = ["${REPO}:8.0", "${REPO}:${PHP80_MINOR}", "${REPO}:8.0-latest"]
}

target "fpm-8.0" {
  inherits = ["common", "fpm", "base-8.0"]
  tags = ["${REPO}:8.0-fpm", "${REPO}:${PHP80_MINOR}-fpm", "${REPO}:8.0-fpm-latest"]
}
