variable "REPO_DRUPAL_TEST" {
  default = "druidfi/drupal-test"
}

group "default" {
  targets = ["drupal-test-83", "drupal-test-84"]
}

target "common" {
  context = "./drupal-test"
  platforms = ["linux/amd64", "linux/arm64"]
}

#
# Drupal Test
#

target "drupal-test-83" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.3"
  }
  tags = ["${REPO_DRUPAL_TEST}:php-8.3"]
}

target "drupal-test-84" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.4"
  }
  tags = ["${REPO_DRUPAL_TEST}:php-8.4"]
}
