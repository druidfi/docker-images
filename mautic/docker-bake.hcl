variable "REPO_BASE" {
  default = "druidfi/mautic"
}

group "default" {
  targets = ["mautic-variants"]
}

group "mautic-variants" {
  targets = ["mautic-52"]
}

target "common" {
  context = "./mautic"
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.url" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.source" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.licenses" = "MIT"
    "org.opencontainers.image.vendor" = "Druid Oy"
    "org.opencontainers.image.created" = "${timestamp()}"
  }
}

#
# MAUTIC
#

target "mautic-52" {
  inherits = ["common"]
  args = {
  }
  contexts = {
    mautic_upstream = "docker-image://mautic/mautic:5.2.1-apache"
  }
  tags = [
    "${REPO_BASE}:5.2.1"
  ]
}
