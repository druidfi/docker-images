variable NGINX_STABLE_VERSION {
  default = "1.20"
}

variable NGINX_MAINLINE_VERSION {
  default = "1.21"
}

group "default" {
  targets = ["base-stable", "drupal-stable", "base-mainline", "drupal-mainline"]
}

target "common" {
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
