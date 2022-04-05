group "default" {
  targets = ["mariadb-variants", "mysql-variants"]
}

group "mariadb-variants" {
  targets = ["mariadb-105", "mariadb-106", "mariadb-107"]
}

group "mysql-variants" {
  targets = ["mysql-57", "mysql-80"]
}

target "mariadb-common" {
  context = "./db/mariadb"
  platforms = ["linux/amd64", "linux/arm64"]
}

target "mariadb-105" {
  inherits = ["mariadb-common"]
  args = {
    MARIADB_VERSION = "10.5"
  }
  tags = ["druidfi/mariadb:10.5-drupal", "druidfi/mariadb:latest"]
}

target "mariadb-106" {
  inherits = ["mariadb-common"]
  args = {
    MARIADB_VERSION = "10.6"
  }
  tags = ["druidfi/mariadb:10.6-drupal"]
}

target "mariadb-107" {
  inherits = ["mariadb-common"]
  args = {
    MARIADB_VERSION = "10.7"
  }
  tags = ["druidfi/mariadb:10.7-drupal"]
}

target "mysql-common" {
  context = "./db/mysql"
  platforms = ["linux/amd64"]
}

target "mysql-57" {
  inherits = ["mysql-common"]
  target = "mysql-base"
  args = {
    MYSQL_VERSION = "5.7"
    MYSQL_SHORT_VERSION = "57"
  }
  tags = ["druidfi/mysql:5.7-drupal"]
}

target "mysql-80" {
  inherits = ["mysql-common"]
  target = "mysql-base"
  args = {
    MYSQL_VERSION = "8.0"
    MYSQL_SHORT_VERSION = "80"
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["druidfi/mysql:8.0-drupal", "druidfi/mysql:latest"]
}
