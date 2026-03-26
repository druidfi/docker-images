variable NGINX_STABLE_VERSION {
  default = "1.28"
}

variable NGINX_MAINLINE_VERSION {
  default = "1.29"
}

group "default" {
  targets = ["stable", "mainline", "placeholder"]
}

group "stable" {
  targets = ["base-stable", "drupal-stable"]
}

group "mainline" {
  targets = ["base-mainline", "drupal-mainline"]
}

group "placeholder" {
  targets = ["placeholder"]
}

target "common" {
  context = "./nginx"
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.url" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.source" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.licenses" = "MIT"
    "org.opencontainers.image.vendor" = "Druid Oy"
    "org.opencontainers.image.created" = timestamp()
  }
}

target "common-stable" {
  inherits = ["common"]
  args = {
    NGINX_VERSION = NGINX_STABLE_VERSION
  }
}

target "common-mainline" {
  inherits = ["common"]
  args = {
    NGINX_VERSION = NGINX_MAINLINE_VERSION
  }
}

target "base-stable" {
  inherits = ["common-stable"]
  target = "base"
  tags = [
    "druidfi/nginx:${NGINX_STABLE_VERSION}",
    "druidfi/nginx:stable"
  ]
}

target "drupal-stable" {
  inherits = ["common-stable"]
  target = "drupal"
  tags = [
    "druidfi/nginx:${NGINX_STABLE_VERSION}-drupal",
    "druidfi/nginx:stable-drupal"
  ]
}

target "base-mainline" {
  inherits = ["common-mainline"]
  target = "base"
  tags = [
    "druidfi/nginx:${NGINX_MAINLINE_VERSION}",
    "druidfi/nginx:mainline"
  ]
}

target "drupal-mainline" {
  inherits = ["common-mainline"]
  target = "drupal"
  tags = [
    "druidfi/nginx:${NGINX_MAINLINE_VERSION}-drupal",
    "druidfi/nginx:mainline-drupal"
  ]
}

target "placeholder" {
  inherits = ["common-mainline"]
  target = "placeholder"
  tags = [
    "druidfi/nginx:placeholder",
    "ghcr.io/druidfi/nginx:placeholder"
  ]
}
