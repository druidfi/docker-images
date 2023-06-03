variable NGINX_STABLE_VERSION {
  default = "1.24"
}

variable NGINX_MAINLINE_VERSION {
  default = "1.25"
}

group "default" {
  targets = ["stable", "mainline"]
}

group "stable" {
  targets = ["base-stable", "drupal-stable"]
}

group "mainline" {
  targets = ["base-mainline", "drupal-mainline"]
}

target "common" {
  context = "./nginx"
  platforms = ["linux/amd64", "linux/arm64"]
}

target "common-stable" {
  inherits = ["common"]
  args = {
    NGINX_VERSION = "${NGINX_STABLE_VERSION}"
  }
}

target "common-mainline" {
  inherits = ["common"]
  args = {
    NGINX_VERSION = "${NGINX_MAINLINE_VERSION}"
  }
}

target "base-stable" {
  inherits = ["common-stable"]
  target = "base"
  tags = ["druidfi/nginx:${NGINX_STABLE_VERSION}", "druidfi/nginx:stable"]
}

target "drupal-stable" {
  inherits = ["common-stable"]
  target = "drupal"
  tags = ["druidfi/nginx:${NGINX_STABLE_VERSION}-drupal", "druidfi/nginx:stable-drupal"]
}

target "base-mainline" {
  inherits = ["common-mainline"]
  target = "base"
  tags = ["druidfi/nginx:${NGINX_MAINLINE_VERSION}", "druidfi/nginx:mainline"]
}

target "drupal-mainline" {
  inherits = ["common-mainline"]
  target = "drupal"
  tags = ["druidfi/nginx:${NGINX_MAINLINE_VERSION}-drupal", "druidfi/nginx:mainline-drupal"]
}
