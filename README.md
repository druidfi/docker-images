# General use Docker images for projects

See https://hub.docker.com/u/druidfi for all the images.
## druidfi/base

### `alpine3.11` 

Features:

- Workdir: `/app`
- User: `druid (1000)`
- Packages installed: `bash`, `curl`, `git` and `tini`

ENV variables:

- `KIND=druid-docker-image`

## druidfi/php

### `7.3` based on `druidfi/base:alpine3.11`

Added features:

- Minimal set of PHP extensions
- Composer 1.9
- hirak/prestissimo Composer plugin
- `/app/vendor/bin` added  to `$PATH`

### `7.3-fpm` based on `druidfi/php:7.3`

Added features:

- PHP-FPM running

## druidfi/drupal

### `7.3` based on `druidfi/php:7.3-fpm`

Added features:

- PHP extensions needed by Drupal

Needs:

- Nginx (`druidfi/nginx-drupal:1.17`)
- Database (`mysql:5.7`)

ENV variables:

- `KIND=druid-docker-image`
- `DRUPAL_DB_NAME=drupal`
- `DRUPAL_DB_USER=drupal`
- `DRUPAL_DB_PASS=drupal`
- `DRUPAL_DB_HOST=db`
- `DRUPAL_DB_PORT=3306`
- `DRUSH_OPTIONS_URI=http://drupal.docker.sh`

### `7.3-web` based on `druidfi/drupal:7.3`

Added features:

- Nginx with Drupal specific configuration

Needs:

- Database (`mysql:5.7`)

### `7.3-web-openshift` based on `druidfi/drupal:7.3-web`

Added features:

- s2i scripts (run, assemble, save-artifacts, usage)
- Runs as UID 1000

Needs:

- Database

### `7.3-test` based on `druidfi/drupal:7.3-web`

Added features:

- Drupal 8 installation

Needs:

- Database (`mysql:5.7`)

## druidfi/nginx

### `1.17` based on `nginx:1.17-alpine`

Added features:

- Default Nginx configuration

### `1.17-drupal` based on `druidfi/nginx:1.17`

Added features on `1.17-drupal`:

- Drupal specific Nginx configuration
- Expects that PHP in running at `php:9000`
