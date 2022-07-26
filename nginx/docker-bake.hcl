variable NGINX_STABLE_VERSION {
  default = "1.22"
}

variable NGINX_MAINLINE_VERSION {
  default = "1.23"
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
  tags = ["druidfi/nginx:${NGINX_STABLE_VERSION}"]
}

target "drupal-stable" {
  inherits = ["common-stable"]
  target = "drupal"
  tags = ["druidfi/nginx:${NGINX_STABLE_VERSION}-drupal"]
}

target "base-mainline" {
  inherits = ["common-mainline"]
  target = "base"
  tags = ["druidfi/nginx:${NGINX_MAINLINE_VERSION}"]
}

target "drupal-mainline" {
  inherits = ["common-mainline"]
  target = "drupal"
  tags = ["druidfi/nginx:${NGINX_MAINLINE_VERSION}-drupal"]
}
