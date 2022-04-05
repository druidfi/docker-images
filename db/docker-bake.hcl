group "default" {
  targets = ["mariadb-variants", "mysql-variants"]
}

group "mariadb-variants" {
  targets = ["mariadb-105", "mariadb-106"]
}

group "mysql-variants" {
  targets = ["mysql-57", "mysql-80"]
}

target "mariadb-105" {
  context = "./mariadb"
  args = {
    MARIADB_VERSION = "10.5"
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["druidfi/mariadb:10.5-drupal", "druidfi/mariadb:latest"]
}

target "mariadb-106" {
  context = "./mariadb"
  args = {
    MARIADB_VERSION = "10.6"
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["druidfi/mariadb:10.6-drupal"]
}

target "mysql" {
  context = "./mysql"
  platforms = ["linux/amd64"]
}

target "mysql-57" {
  inherits = ["mysql"]
  target = "mysql-base"
  args = {
    MYSQL_VERSION = "5.7"
    MYSQL_SHORT_VERSION = "57"
  }
  tags = ["druidfi/mysql:5.7-drupal"]
}

target "mysql-80" {
  inherits = ["mysql"]
  target = "mysql-base"
  args = {
    MYSQL_VERSION = "8.0"
    MYSQL_SHORT_VERSION = "80"
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["druidfi/mysql:8.0-drupal", "druidfi/mysql:latest"]
}
