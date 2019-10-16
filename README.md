# General use Docker images for projects

## druidfi/base

### `alpine3.10`

Features:

- Workdir: `/app`
- User: `druid (1000)`
- Packages installed: `bash`, `curl`, `git` and `tini`

ENV variables:

- `KIND=druid-docker-image`

## druidfi/php

### `7.3-fpm` based on `druidfi/base:alpine3.10`

Added features:

- Minimal set of PHP extensions
- Composer 1.9
- hirak/prestissimo Composer plugin
- `/app/vendor/bin` added  to `$PATH`

## druidfi/drupal

### `7.3` based on `druidfi/php:7.3-fpm`

Added features:

- PHP extensions needed by Drupal

Needs:

- Nginx (`druidfi/nginx-drupal:1.17`)
- Database (`mysql:5.7`)

### `7.3-web` based on `druidfi/drupal:7.3`

Added features:

- Nginx with Drupal specific configuration

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
