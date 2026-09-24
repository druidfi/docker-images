variable "REPO_DRUPAL_TEST" {
  default = "druidfi/drupal-test"
}

group "default" {
  targets = ["drupal-test-84", "drupal-test-85"]
}

target "common" {
  context = "./drupal-test"
  platforms = ["linux/amd64", "linux/arm64"]
}

#
# Drupal Test
#

target "drupal-test-84" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.4"
  }
  tags = ["${REPO_DRUPAL_TEST}:php-8.4"]
}

target "drupal-test-85" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.5"
  }
  tags = ["${REPO_DRUPAL_TEST}:php-8.5"]
}
