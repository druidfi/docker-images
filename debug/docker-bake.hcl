variable "PHP81_MINOR" {}
variable "PHP82_MINOR" {}

variable "REPO_SYMFONY_FPM" {
  default = "debug/symfony-php"
}

variable "REPO_SYMFONY_WEB" {
  default = "debug/symfony-web"
}

group "default" {
  targets = ["symfony-fpm-variants", "symfony-web-variants"]
}

group "symfony-fpm-variants" {
  targets = ["symfony-fpm-81", "symfony-fpm-82"]
}

group "symfony-web-variants" {
  targets = ["symfony-web-81", "symfony-web-82"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
  context = "./debug"
}

target "symfony-fpm-81" {
  inherits = ["common"]
  target = "symfony-fpm"
  contexts = {
    php-fpm-base = "docker-image://php:8.1-fpm-alpine"
  }
  tags = ["${REPO_SYMFONY_FPM}:fpm-8.1", "${REPO_SYMFONY_FPM}:fpm-${PHP81_MINOR}"]
}

target "symfony-fpm-82" {
  inherits = ["common"]
  target = "symfony-fpm"
  contexts = {
    php-fpm-base = "docker-image://php:8.2-fpm-alpine"
  }
  tags = ["${REPO_SYMFONY_FPM}:fpm-8.2", "${REPO_SYMFONY_FPM}:fpm-${PHP82_MINOR}"]
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
