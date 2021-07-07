# General use Docker images for projects

![PHP images](https://github.com/druidfi/docker-images/workflows/PHP%20images/badge.svg)
![Node images](https://github.com/druidfi/docker-images/workflows/Node%20images/badge.svg)
![Database images](https://github.com/druidfi/docker-images/workflows/Database%20images/badge.svg)
![Misc images](https://github.com/druidfi/docker-images/workflows/Misc%20images/badge.svg)

See https://hub.docker.com/u/druidfi for all the images.

## Essential images

### PHP base images

Name | Tags | Baseimage
--- | ------ | -----------
druidfi/php | 7.3, 7.3.x | druidfi/alpine-3.12.7
druidfi/php | 7, 7.4, 7.4.x, latest | druidfi/alpine-3.14.0
druidfi/php | 8, 8.0, 8.0.x | druidfi/alpine-3.14.0

### PHP FPM images

Name | Tags | Baseimage
--- | ------ | -----------
druidfi/php-fpm | 7.3, 7.3.x | druidfi/php:7.3
druidfi/php-fpm | 7, 7.4, 7.4.x, latest | druidfi/php:7.4
druidfi/php-fpm | 8, 8.0, 8.0.x | druidfi/php:8.0

### Drupal images

Name | Tags | Baseimage
--- | ------ | -----------
druidfi/drupal | php-7.3, php-7.3.x | druidfi/php-fpm:7.3
druidfi/drupal | php-7, php-7.4, php-7.4.x, latest | druidfi/php-fpm:7.4
druidfi/drupal | php-8, php-8.0, php-8.0.x | druidfi/php-fpm:8.0

### Drupal web images (incl. Nginx)

Name | Tags | Baseimage
--- | ------ | -----------
druidfi/drupal-web | php-7.3, php-7.3.x | druidfi/drupal:php-7.3
druidfi/drupal-web | php-7, php-7.4, php-7.4.x, latest | druidfi/drupal:php-7.4
druidfi/drupal-web | php-8, php-8.0, php-8.0.x | druidfi/drupal:php-8.0

### Nginx images

Name | Tags | Baseimage
--- | ------ | -----------
druidfi/nginx | 1.20 | nginx:1.20-alpine
druidfi/nginx | 1.20-drupal | nginx:1.20-alpine

## druidfi/base

Features:

- Workdir: `/app`
- User: `druid (1000)` and added to sudoers
- Packages installed: `bash`, `curl`, `git`, `make`, `nano` and `tini`

ENV variables:

- `ALPINE_VERSION=3.14.0`
- `APP_PATH=/app`
- `DEFAULT_USER=druid`
- `DEFAULT_USER_UID=1000`
- `KIND=druid-docker-image`

## druidfi/php

### Base variant

- `druidfi/php:7.3` based on `druidfi/base:alpine3.12.7`
- `druidfi/php:7.4` based on `druidfi/base:alpine3.13.5`
- `druidfi/php:8.0` based on `druidfi/base:alpine3.13.5`

Added features:

- Minimal set of PHP extensions
- Composer 2.x.x
- `/app/vendor/bin` added  to `$PATH`

### FPM variant

- `druidfi/php-fpm:7.3` based on `druidfi/php:7.3`
- `druidfi/php-fpm:7.4` based on `druidfi/php:7.4`
- `druidfi/php-fpm:8.0` based on `druidfi/php:8.0`

Added features:

- PHP-FPM running and configured

## druidfi/drupal

### Base variant

- `druidfi/drupal:7.3` based on `druidfi/php-fpm:7.3`
- `druidfi/drupal:7.4` based on `druidfi/php-fpm:7.4`
- `druidfi/drupal:8.0` based on `druidfi/php-fpm:8.0`

Added features:

- PHP extensions needed by Drupal

Needs:

- Nginx (`druidfi/nginx:1.20-drupal`)
- Database (`druidfi/db:mysql8.0-drupal`)

ENV variables:

- `DRUPAL_DB_NAME=drupal`
- `DRUPAL_DB_USER=drupal`
- `DRUPAL_DB_PASS=drupal`
- `DRUPAL_DB_HOST=db`
- `DRUPAL_DB_PORT=3306`

### Web variant

- `druidfi/drupal-web:7.3` based on `druidfi/drupal:7.3`
- `druidfi/drupal-web:7.4` based on `druidfi/drupal:7.4`
- `druidfi/drupal-web:8.0` based on `druidfi/drupal:8.0`

Added features:

- Nginx with Drupal specific configuration

Needs:

- Database (`druidfi/db:mysql8.0-drupal`)

### Test variant

- `druidfi/drupal-test:7.3` based on `druidfi/drupal-web:7.3`
- `druidfi/drupal-test:7.4` based on `druidfi/drupal-web:7.4`

Added features:

- Drupal 9 installation

Needs:

- Database (`druidfi/db:mysql8.0-drupal`)

## druidfi/nginx

### Base variant

- `1.20` based on `nginx:1.20-alpine`

Added features:

- Default Nginx configuration

### Drupal variant

- `1.20-drupal` based on `druidfi/nginx:1.20`

Added features on `1.20-drupal`:

- Drupal specific Nginx configuration
- Expects that PHP in running at `php:9000`
