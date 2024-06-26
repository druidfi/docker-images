group "default" {
  targets = ["mariadb-variants", "mysql-variants"]
}

group "mariadb-variants" {
  targets = ["mariadb-106", "mariadb-1011", "mariadb-114"]
}

group "mysql-variants" {
  targets = ["mysql-57", "mysql-80", "mysql-84"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.url" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.source" = "https://github.com/druidfi/docker-images"
    "org.opencontainers.image.licenses" = "MIT"
    "org.opencontainers.image.vendor" = "Druid Oy"
    "org.opencontainers.image.created" = "${timestamp()}"
  }
}

target "mariadb-common" {
  context = "./db/mariadb"
}

target "mariadb-106" {
  inherits = ["common", "mariadb-common"]
  args = {
    MARIADB_VERSION = "10.6"
  }
  tags = ["druidfi/mariadb:10.6-drupal", "druidfi/mariadb:10.6-drupal-lts"]
}

target "mariadb-1011" {
  inherits = ["common", "mariadb-common"]
  args = {
    MARIADB_VERSION = "10.11"
  }
  tags = ["druidfi/mariadb:10.11-drupal", "druidfi/mariadb:10.11-drupal-lts"]
}

target "mariadb-114" {
  inherits = ["common", "mariadb-common"]
  args = {
    MARIADB_VERSION = "11.4"
  }
  tags = ["druidfi/mariadb:11.4-drupal", "druidfi/mariadb:11.4-drupal-lts", "druidfi/mariadb:latest"]
}

target "mysql-common" {
  context = "./db/mysql"
}

target "mysql-57" {
  inherits = ["common", "mysql-common"]
  target = "mysql-base"
  args = {
    MYSQL_VERSION = "5.7"
    MYSQL_SHORT_VERSION = "57"
  }
  tags = ["druidfi/mysql:5.7-drupal"]
}

target "mysql-80" {
  inherits = ["common", "mysql-common"]
  target = "mysql-base"
  args = {
    MYSQL_VERSION = "8.0"
    MYSQL_SHORT_VERSION = "80"
  }
  tags = ["druidfi/mysql:8.0-drupal", "druidfi/mysql:8.0-drupal-lts"]
}

target "mysql-84" {
  inherits = ["common", "mysql-common"]
  target = "mysql-base"
  args = {
    MYSQL_VERSION = "8.4"
    MYSQL_SHORT_VERSION = "84"
  }
  tags = ["druidfi/mysql:8.4-drupal", "druidfi/mysql:8.4-drupal-lts", "druidfi/mysql:latest"]
}
