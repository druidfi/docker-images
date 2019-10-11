# General use Docker images for projects

## druidfi/base

Tags:

- `alpine3.10`

Features:

- Workdir: `/app`
- User: `druid (1000)`

## druidfi/php

Tags:

- `7.3-fpm-alpine3.10` based on `druidfi/base:alpine3.10`

Added features:

- Minimal set of PHP extensions
- Composer 1.9

## druidfi/drupal

Tags:

- `7.3-fpm-alpine3.10` based on `druidfi/php:7.3-fpm-alpine3.10`

Added features:

- PHP extensions needed by Drupal
