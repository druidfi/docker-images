variable "REPO" {
  default = "druidfi/drupalx"
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
  targets = ["base-7.3", "web-7.3", "base-7.4", "web-7.4", "base-8.0", "web-8.0"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
}

target "base" {
  context = "./base"
}

target "web" {
  context = "./web"
  args = {
    NGINX_VERSION = "1.20"
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

target "web-7.3" {
  inherits = ["common", "web", "base-7.3"]
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
  inherits = ["common", "web", "base-7.4"]
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
  inherits = ["common", "web", "base-8.0"]
  tags = ["${REPO}:8.0-web", "${REPO}:${PHP80_MINOR}-web", "${REPO}:8.0-web-latest"]
}
