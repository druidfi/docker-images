group "default" {
  targets = ["mariadb-variants", "mysql-variants"]
}

group "mariadb-variants" {
  targets = ["mariadb-106", "mariadb-1011"]
}

group "mysql-variants" {
  targets = ["mysql-57", "mysql-80", "mysql-81"]
}

target "mariadb-common" {
  context = "./db/mariadb"
  platforms = ["linux/amd64", "linux/arm64"]
}

target "mariadb-106" {
  inherits = ["mariadb-common"]
  args = {
    MARIADB_VERSION = "10.6"
  }
  tags = ["druidfi/mariadb:10.6-drupal", "druidfi/mariadb:10.6-drupal-lts"]
}

target "mariadb-1011" {
  inherits = ["mariadb-common"]
  args = {
    MARIADB_VERSION = "10.11"
  }
  tags = ["druidfi/mariadb:10.11-drupal", "druidfi/mariadb:10.11-drupal-lts", "druidfi/mariadb:latest"]
}

target "mysql-common" {
  context = "./db/mysql"
  platforms = ["linux/amd64", "linux/arm64"]
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
  tags = ["druidfi/mysql:8.0-drupal", "druidfi/mysql:latest"]
}

target "mysql-81" {
  inherits = ["mysql-common"]
  target = "mysql-base"
  args = {
    MYSQL_VERSION = "8.1"
    MYSQL_SHORT_VERSION = "81"
  }
  tags = ["druidfi/mysql:8.1-drupal", "druidfi/mysql:latest"]
}
