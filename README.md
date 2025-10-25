# General use Docker images for projects

![PHP images](https://github.com/druidfi/docker-images/workflows/PHP%20images/badge.svg)
![Nginx images](https://github.com/druidfi/docker-images/workflows/Nginx%20images/badge.svg)
![Database images](https://github.com/druidfi/docker-images/workflows/Database%20images/badge.svg)
![Misc images](https://github.com/druidfi/docker-images/workflows/Misc%20images/badge.svg)

See https://hub.docker.com/u/druidfi for all the images.

## Shared for all PHP images

Features:

- Workdir: `/app`
- User: `druid (1000)` and added to sudoers
- Packages installed: `bash`, `curl`, `git`, `make`, `nano`, `neofetch` and `tini`
- SHELL: bash
- Entrypoint with tini

ENV variables:

- `ALPINE_VERSION`
- `APP_PATH=/app`
- `DEFAULT_USER=druid`
- `DEFAULT_USER_UID=1000`
- `KIND=druid-docker-image`

### druidfi/php variant

Tags:

- `druidfi/php:8`, `druidfi/php:8.3`, `druidfi/php:8.3.x` and `druidfi/php:latest`
- `druidfi/php:8.4` and `druidfi/php:8.4.x`

Added features:

- Minimal set of PHP extensions
- Composer 2.x.x
- `/app/vendor/bin` added  to `$PATH`

### druidfi/php-fpm variant

Tags:

- `druidfi/php-fpm:8`, `druidfi/php-fpm:8.3`, `druidfi/php-fpm:8.3.x` and `druidfi/php-fpm:latest`
- `druidfi/php-fpm:8.4` and `druidfi/php-fpm:8.4.x`

Added features:

- PHP-FPM running and configured
- PHP-FPM runs with `www-data:www-data`

### druidfi/drupal variant

Tags:

- `druidfi/drupal:php-8`, `druidfi/drupal:php-8.3`, `druidfi/drupal:php-8.3.x` and `druidfi/drupal:latest`
- `druidfi/drupal:php-8.4` and `druidfi/drupal:php-8.4.x`

Added features:

- PHP extensions needed by Drupal

Needs:

- Nginx (`druidfi/nginx:1.27-drupal`)
- Database (`druidfi/mariadb:10.11-drupal-lts`)

ENV variables:

- `DRUPAL_DB_NAME=drupal`
- `DRUPAL_DB_USER=drupal`
- `DRUPAL_DB_PASS=drupal`
- `DRUPAL_DB_HOST=db`
- `DRUPAL_DB_PORT=3306`

### druidfi/drupal-web variant

- `druidfi/drupal-web:php-8`, `druidfi/drupal-web:php-8.3`, `druidfi/drupal-web:php-8.3.x`, `druidfi/drupal-web:v8.3.x` and `druidfi/drupal-web:latest`
- `druidfi/drupal-web:php-8.4`, `druidfi/drupal-web:php-8.4.x` and `druidfi/drupal-web:v8.4.x`

Added features:

- Nginx with Drupal specific configuration
- Nginx runs with user `nginx`

Needs:

- Database (`druidfi/mariadb:10.11-drupal-lts`)

### druidfi/drupal-test variant

- `druidfi/drupal-test:8.4` based on `druidfi/drupal-web:8.4`

Added features:

- Drupal 10 installation and some contrib modules

Needs:

- Database (`druidfi/mariadb:10.11-drupal-lts`)

## druidfi/nginx

### Base variant

- `1.26` stable based on `nginx:1.26-alpine`
- `1.27` mainline based on `nginx:1.27-alpine`

Added features:

- Default Nginx configuration

### Drupal variant

- `1.26-drupal` based on `druidfi/nginx:1.26`
- `1.27-drupal` based on `druidfi/nginx:1.27`

Added features:

- Drupal specific Nginx configuration
- Expects that PHP in running at `app:9000`
- PHP backend can be changed with `BACKEND_SERVICE=app` and `BACKEND_SERVICE_PORT=9000`
