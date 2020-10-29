# General use Docker images for projects

See https://hub.docker.com/u/druidfi for all the images.

## Requirements

- `DOCKER_BUILDKIT=1` << this is enabled on build commands.

## druidfi/base

Tags:

- `druidfi/base:alpine3.12`

Features:

- Workdir: `/app`
- User: `druid (1000)` and added to sudoers
- Packages installed: `bash`, `curl`, `git`, `make`, `nano` and `tini`

ENV variables:

- `ALPINE_VERSION=3.12`
- `APP_PATH=/app`
- `DEFAULT_USER=druid`
- `DEFAULT_USER_UID=1000`
- `KIND=druid-docker-image`

## druidfi/php

### Base variant

- `druidfi/php:7.3` based on `druidfi/base:alpine3.12`
- `druidfi/php:7.4` based on `druidfi/base:alpine3.12`

Added features:

- Minimal set of PHP extensions
- Composer 2.0.x
- `/app/vendor/bin` added  to `$PATH`

### FPM variant

- `druidfi/php:7.3-fpm` based on `druidfi/php:7.3`
- `druidfi/php:7.4-fpm` based on `druidfi/php:7.4`

Added features:

- PHP-FPM running

## druidfi/drupal

### Base variant

- `druidfi/drupal:7.3` based on `druidfi/php:7.3-fpm`
- `druidfi/drupal:7.4` based on `druidfi/php:7.4-fpm`

Added features:

- PHP extensions needed by Drupal

Needs:

- Nginx (`druidfi/nginx-drupal:1.18`)
- Database (`mysql:5.7`)

ENV variables:

- `KIND=druid-docker-image`
- `DRUPAL_DB_NAME=drupal`
- `DRUPAL_DB_USER=drupal`
- `DRUPAL_DB_PASS=drupal`
- `DRUPAL_DB_HOST=db`
- `DRUPAL_DB_PORT=3306`
- `DRUSH_OPTIONS_URI=http://drupal.docker.sh`

### Web variant

- `druidfi/drupal:7.3-web` based on `druidfi/drupal:7.3`
- `druidfi/drupal:7.4-web` based on `druidfi/drupal:7.4`

Added features:

- Nginx with Drupal specific configuration

Needs:

- Database (`mysql:5.7`)

### Test variant

- `druidfi/drupal:7.3-test` based on `druidfi/drupal:7.3-web`

Added features:

- Drupal 8 installation

Needs:

- Database (`mysql:5.7`)

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
