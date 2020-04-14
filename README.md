# General use Docker images for projects

See https://hub.docker.com/u/druidfi for all the images.

[![buddy pipeline](https://app.buddy.works/druid/docker-images/pipelines/pipeline/247351/badge.svg?token=00e9b792cb528237d5cb48cfc2a8ef03098512d5e45465b2e948702e16c0d6e0 "buddy pipeline")](https://app.buddy.works/druid/docker-images/pipelines/pipeline/247351)

## druidfi/base

Tags:

- `druidfi/base:alpine3.11`
- `druidfi/base:alpine3.7`

Features:

- Workdir: `/app`
- User: `druid (1000)` and added to sudoers
- Packages installed: `bash`, `curl`, `git`, `make`, `nano` and `tini`

ENV variables:

- `ALPINE_VERSION=3.11|3.7`
- `APP_PATH=/app`
- `DEFAULT_USER=druid`
- `DEFAULT_USER_UID=1000`
- `KIND=druid-docker-image`

## druidfi/php

### Base variant

- `druidfi/php:7.3` based on `druidfi/base:alpine3.11`
- `druidfi/php:7.1` based on `druidfi/base:alpine3.7`

Added features:

- Minimal set of PHP extensions
- Composer 1.10.x
- hirak/prestissimo Composer plugin
- `/app/vendor/bin` added  to `$PATH`

### FPM variant

- `druidfi/php:7.3-fpm` based on `druidfi/php:7.3`
- `druidfi/php:7.1-fpm` based on `druidfi/php:7.1`

Added features:

- PHP-FPM running

## druidfi/drupal

### Base variant

- `druidfi/drupal:7.3` based on `druidfi/php:7.3-fpm`
- `druidfi/drupal:7.1` based on `druidfi/php:7.1-fpm`

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

### Web variant

- `druidfi/drupal:7.3-web` based on `druidfi/drupal:7.3`
- `druidfi/drupal:7.1-web` based on `druidfi/drupal:7.1`

Added features:

- Nginx with Drupal specific configuration

Needs:

- Database (`mysql:5.7`)

### OpenShift variant

- `druidfi/drupal:7.3-web-openshift` based on `druidfi/drupal:7.3-web`

Added features:

- s2i scripts (run, assemble, save-artifacts, usage)
- Runs as UID 1000

Needs:

- Database

### Test variant

- `druidfi/drupal:7.3-test` based on `druidfi/drupal:7.3-web`

Added features:

- Drupal 8 installation

Needs:

- Database (`mysql:5.7`)

## druidfi/nginx

### Base variant

- `1.17` based on `nginx:1.17-alpine`

Added features:

- Default Nginx configuration

### Drupal variant

- `1.17-drupal` based on `druidfi/nginx:1.17`

Added features on `1.17-drupal`:

- Drupal specific Nginx configuration
- Expects that PHP in running at `php:9000`
