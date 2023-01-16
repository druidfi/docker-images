variable "PHP81_MINOR" {}
variable "PHP82_MINOR" {}

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
  targets = ["symfony-fpm-81", "symfony-fpm-82"]
}

group "symfony-web-variants" {
  targets = ["symfony-web-81", "symfony-web-82"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
  context = "./symfony"
}

target "symfony-fpm-81" {
  inherits = ["common"]
  contexts = {
    php-fpm-base = "docker-image://php:8.1-fpm-alpine"
  }
  target = "symfony-fpm"
  tags = ["${REPO_SYMFONY_FPM}:fpm-8.1", "${REPO_SYMFONY_FPM}:fpm-${PHP81_MINOR}"]
}

target "symfony-fpm-82" {
  inherits = ["common"]
  contexts = {
    php-fpm-base = "docker-image://php:8.2-fpm-alpine"
  }
  target = "symfony-fpm"
  tags = ["${REPO_SYMFONY_FPM}:fpm-8.2", "${REPO_SYMFONY_FPM}:fpm-${PHP82_MINOR}"]
}

target "symfony-caddy-2" {
  inherits = ["common"]
  target = "symfony-caddy-2"
  tags = ["${REPO_SYMFONY_CADDY}:2"]
}

target "symfony-web-81" {
  inherits = ["common", "symfony-fpm-81"]
  target = "symfony-web"
  tags = ["${REPO_SYMFONY_WEB}:php-8.1", "${REPO_SYMFONY_WEB}:php-${PHP81_MINOR}"]
}

target "symfony-web-82" {
  inherits = ["common", "symfony-fpm-82"]
  target = "symfony-web"
  tags = ["${REPO_SYMFONY_WEB}:php-8.2", "${REPO_SYMFONY_WEB}:php-${PHP82_MINOR}"]
}
