# General use Docker images for projects

See https://hub.docker.com/u/druidfi for all the images.

## Requirements

- `DOCKER_BUILDKIT=1` << this is enabled on build commands.

## Essential images

### PHP images

Name | Tag | Baseimage | yyy
--- | ------ | ----------- | ---
druidfi/php | 7.3 | alpine:3.12.3 | -
druidfi/php | 7.3-fpm | alpine:3.12.3 | -
druidfi/php | 7.4 | alpine:3.13 | -
druidfi/php | 7.4-fpm | alpine:3.13 | -
druidfi/php | 8.0 | alpine:3.13 | -
druidfi/php | 8.0-fpm | alpine:3.13 | -

### Drupal images

Name | Tag | Baseimage | yyy
--- | ------ | ----------- | ---
druidfi/drupal | 7.3 | alpine:3.12.3 | -
druidfi/drupal | 7.3-web | alpine:3.12.3 | -
druidfi/drupal | 7.4 | alpine:3.13 | -
druidfi/drupal | 7.4-web | alpine:3.13 | -
druidfi/drupal | 8.0 | alpine:3.13 | -
druidfi/drupal | 8.0-web | alpine:3.13 | -

### Nginx images

Name | Tag | Baseimage | yyy
--- | ------ | ----------- | ---
druidfi/nginx | 1.18 | nginx:1.18-alpine | -
druidfi/nginx | 1.18-drupal | nginx:1.18-alpine | -

## druidfi/base

Features:

- Workdir: `/app`
- User: `druid (1000)` and added to sudoers
- Packages installed: `bash`, `curl`, `git`, `make`, `nano` and `tini`

ENV variables:

- `ALPINE_VERSION=3.13`
- `APP_PATH=/app`
- `DEFAULT_USER=druid`
- `DEFAULT_USER_UID=1000`
- `KIND=druid-docker-image`

## druidfi/php

### Base variant

- `druidfi/php:7.3` based on `druidfi/base:alpine3.12.3`
- `druidfi/php:7.4` based on `druidfi/base:alpine3.13`
- `druidfi/php:8.0` based on `druidfi/base:alpine3.13`

Added features:

- Minimal set of PHP extensions
- Composer 2.0.x
- `/app/vendor/bin` added  to `$PATH`

### FPM variant

- `druidfi/php:7.3-fpm` based on `druidfi/php:7.3`
- `druidfi/php:7.4-fpm` based on `druidfi/php:7.4`
- `druidfi/php:8.0-fpm` based on `druidfi/php:8.0`

Added features:

- PHP-FPM running and configured

## druidfi/drupal

### Base variant

- `druidfi/drupal:7.3` based on `druidfi/php:7.3-fpm`
- `druidfi/drupal:7.4` based on `druidfi/php:7.4-fpm`
- `druidfi/drupal:8.0` based on `druidfi/php:8.0-fpm`

Added features:

- PHP extensions needed by Drupal

Needs:

- Nginx (`druidfi/nginx:1.18-drupal`)
- Database (`druidfi/db:mysql8.0-drupal`)

ENV variables:

- `DRUPAL_DB_NAME=drupal`
- `DRUPAL_DB_USER=drupal`
- `DRUPAL_DB_PASS=drupal`
- `DRUPAL_DB_HOST=db`
- `DRUPAL_DB_PORT=3306`

### Web variant

- `druidfi/drupal:7.3-web` based on `druidfi/drupal:7.3`
- `druidfi/drupal:7.4-web` based on `druidfi/drupal:7.4`
- `druidfi/drupal:8.0-web` based on `druidfi/drupal:8.0`

Added features:

- Nginx with Drupal specific configuration

Needs:

- Database (`druidfi/db:mysql8.0-drupal`)

### Test variant

- `druidfi/drupal:7.3-test` based on `druidfi/drupal:7.3-web`
- `druidfi/drupal:7.4-test` based on `druidfi/drupal:7.4-web`

Added features:

- Drupal 9 installation

Needs:

- Database (`druidfi/db:mysql8.0-drupal`)

## druidfi/nginx

### Base variant

- `1.18` based on `nginx:1.18-alpine`

Added features:

- Default Nginx configuration

### Drupal variant

- `1.18-drupal` based on `druidfi/nginx:1.18`

Added features on `1.18-drupal`:

- Drupal specific Nginx configuration
- Expects that PHP in running at `php:9000`
