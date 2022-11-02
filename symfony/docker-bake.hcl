variable "PHP81_MINOR" {}

variable "REPO_SYMFONY_FPM" {
  default = "druidfi/symfony-php"
}

variable "REPO_SYMFONY_CADDY" {
  default = "druidfi/symfony-caddy"
}

variable "REPO_SYMFONY_WEB" {
  default = "druidfi/symfony-web"
}

group "default" {
  targets = ["symfony-fpm-variants", "symfony-caddy-2", "symfony-web-variants"]
}

group "symfony-fpm-variants" {
  targets = [ "symfony-fpm-81"]
}

group "symfony-web-variants" {
  targets = [ "symfony-web-81"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
  context = "./symfony"
}

target "symfony-fpm-81" {
  inherits = ["common"]
  target = "symfony-fpm-81"
  args = {
    PHP_VERSION = "8.1"
    PHP_SHORT_VERSION = "81"
  }
  tags = ["${REPO_SYMFONY_FPM}:fpm-8.1", "${REPO_SYMFONY_FPM}:fpm-${PHP81_MINOR}"]
}

target "symfony-caddy-2" {
  inherits = ["common"]
  target = "symfony-caddy-2"
  tags = ["${REPO_SYMFONY_CADDY}:2"]
}

target "symfony-web-81" {
  inherits = ["common", "symfony-fpm-81"]
  target = "symfony-web-81"
  tags = ["${REPO_SYMFONY_WEB}:php-8.1", "${REPO_SYMFONY_WEB}:php-${PHP81_MINOR}"]
}