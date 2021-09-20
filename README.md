# General use Docker images for projects

![PHP images](https://github.com/druidfi/docker-images/workflows/PHP%20images/badge.svg)
![Node images](https://github.com/druidfi/docker-images/workflows/Node%20images/badge.svg)
![Database images](https://github.com/druidfi/docker-images/workflows/Database%20images/badge.svg)
![Misc images](https://github.com/druidfi/docker-images/workflows/Misc%20images/badge.svg)

See https://hub.docker.com/u/druidfi for all the images.

## Essential images

### PHP base images

Name | Tags | Latest
--- | ------ | -----------
druidfi/php | 7.3, 7.3.x | 
druidfi/php | 7, 7.4, 7.4.x | x
druidfi/php | 8, 8.0, 8.0.x | 

### PHP FPM images

Name | Tags | Latest
--- | ------ | -----------
druidfi/php-fpm | 7.3, 7.3.x | 
druidfi/php-fpm | 7, 7.4, 7.4.x | x
druidfi/php-fpm | 8, 8.0, 8.0.x | 

### Drupal images

Name | Tags | Latest
--- | ------ | -----------
druidfi/drupal | php-7.3, php-7.3.x | 
druidfi/drupal | php-7, php-7.4, php-7.4.x | x
druidfi/drupal | php-8, php-8.0, php-8.0.x | 

### Drupal web images (incl. Nginx)

Name | Tags | Latest
--- | ------ | -----------
druidfi/drupal-web | php-7.3, php-7.3.x | 
druidfi/drupal-web | php-7, php-7.4, php-7.4.x | x
druidfi/drupal-web | php-8, php-8.0, php-8.0.x | 

### Nginx images

Name | Tags | Baseimage
--- | ------ | -----------
druidfi/nginx | 1.20, 1.21 | nginx:1.xx-alpine
druidfi/nginx | 1.20-drupal, 1.21-drupal | nginx:1.xx-alpine

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

## druidfi/php variant

- `druidfi/php:7.3`
- `druidfi/php:7.4`
- `druidfi/php:8.0`

Added features:

- Minimal set of PHP extensions
- Composer 2.x.x
- `/app/vendor/bin` added  to `$PATH`

## druidfi/php-fpm variant

- `druidfi/php-fpm:7.3`
- `druidfi/php-fpm:7.4`
- `druidfi/php-fpm:8.0`

Added features:

- PHP-FPM running and configured

## druidfi/drupal variant

- `druidfi/drupal:7.3`
- `druidfi/drupal:7.4`
- `druidfi/drupal:8.0`

Added features:

- PHP extensions needed by Drupal

Needs:

- Nginx (`druidfi/nginx:1.20-drupal`)
- Database (`druidfi/mariadb:10.5-drupal`)

ENV variables:

- `DRUPAL_DB_NAME=drupal`
- `DRUPAL_DB_USER=drupal`
- `DRUPAL_DB_PASS=drupal`
- `DRUPAL_DB_HOST=db`
- `DRUPAL_DB_PORT=3306`

## druidfi/drupal-web variant

- `druidfi/drupal-web:7.3`
- `druidfi/drupal-web:7.4`
- `druidfi/drupal-web:8.0`

Added features:

- Nginx with Drupal specific configuration

Needs:

- Database (`druidfi/mariadb:10.5-drupal`)

### Test variant

- `druidfi/drupal-test:7.3` based on `druidfi/drupal-web:7.3`
- `druidfi/drupal-test:7.4` based on `druidfi/drupal-web:7.4`
- `druidfi/drupal-test:8.0` based on `druidfi/drupal-web:8.0`

Added features:

- Drupal 9 installation and some contrib modules

Needs:

- Database (`druidfi/mariadb:10.5-drupal`)

## druidfi/nginx

### Base variant

- `1.20` stable based on `nginx:1.20-alpine`
- `1.21` mainline based on `nginx:1.21-alpine`

Added features:

- Default Nginx configuration

### Drupal variant

- `1.20-drupal` based on `druidfi/nginx:1.20`
- `1.21-drupal` based on `druidfi/nginx:1.21`

Added features:

- Drupal specific Nginx configuration
- Expects that PHP in running at `app:9000`
- PHP backend can be changed with `BACKEND_SERVICE=app` and `BACKEND_SERVICE_PORT=9000`
