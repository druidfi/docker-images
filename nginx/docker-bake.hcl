variable NGINX_STABLE_VERSION {
  default = "1.20"
}

group "default" {
  targets = ["nginx", "drupal"]
}

target "common" {
  args = {
    NGINX_STABLE_VERSION = "${NGINX_STABLE_VERSION}"
  }
  platforms = ["linux/amd64", "linux/arm64"]
}

target "nginx" {
  inherits = ["common"]
  target = "base"
  tags = ["druidfi/nginx:${NGINX_STABLE_VERSION}"]
}

target "drupal" {
  inherits = ["common"]
  target = "drupal"
  tags = ["druidfi/nginx:${NGINX_STABLE_VERSION}-drupal"]
}
