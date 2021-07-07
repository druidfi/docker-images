group "default" {
  targets = ["mariadb-variants", "mysql-variants"]
}

group "mariadb-variants" {
  targets = ["mariadb-10.5", "mariadb-10.6"]
}

group "mysql-variants" {
  targets = ["mysql-5.7", "mysql-8.0"]
}

target "mariadb-10.5" {
  context = "./mariadb"
  args = {
    MARIADB_VERSION = "10.5"
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["druidfi/mariadb:10.5-drupal", "druidfi/mariadb:latest"]
}

target "mariadb-10.6" {
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

target "mysql-5.7" {
  inherits = ["mysql"]
  args = {
    MYSQL_VERSION = "5.7"
  }
  tags = ["druidfi/mysql:5.7-drupal"]
}

target "mysql-8.0" {
  inherits = ["mysql"]
  args = {
    MYSQL_VERSION = "8.0"
  }
  tags = ["druidfi/mysql:8.0-drupal", "druidfi/mysql:latest"]
}
