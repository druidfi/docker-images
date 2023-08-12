variable "REPO_DRUPAL_TEST" {
  default = "druidfi/drupal-test"
}

group "default" {
  targets = ["drupal-test-82"]
}

target "common" {
  context = "./drupal-test"
  platforms = ["linux/amd64", "linux/arm64"]
}

#
# Drupal Test
#

target "drupal-test-82" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.2"
  }
  tags = ["${REPO_DRUPAL_TEST}:php-8.2"]
}
