variable "REPO_DRUPAL_TEST" {
  default = "druidfi/drupal-test"
}

group "default" {
  targets = ["drupal-test-80", "drupal-test-81", "drupal-test-82"]
}

target "common" {
  context = "./drupal-test"
  platforms = ["linux/amd64", "linux/arm64"]
}

#
# Drupal Test
#

target "drupal-test-80" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.0"
  }
  tags = ["${REPO_DRUPAL_TEST}:php-8.0"]
}

target "drupal-test-81" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.1"
  }
  tags = ["${REPO_DRUPAL_TEST}:php-8.1"]
}

target "drupal-test-82" {
  inherits = ["common"]
  args = {
    PHP_VERSION = "8.2"
  }
  tags = ["${REPO_DRUPAL_TEST}:php-8.2"]
}
