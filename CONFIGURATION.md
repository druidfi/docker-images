# PHP Image Configuration

Reference for PHP extensions, binaries, certificates, and PHP ini settings across all PHP images.

## PHP Settings

### Static Settings

Hardcoded in `php/rootfs/etc/php/conf.d/98_custom.ini` (`php/*` images) and `app/rootfs/usr/local/etc/php/conf.d/docker-php-ext-zzz-custom.ini` (`druidfi/app`).

| Setting | Value | Notes |
|---------|-------|-------|
| `expose_php` | `Off` | |
| `memory_limit` | `512M` | Overridable via env var |
| `date.timezone` | `Europe/Helsinki` | |
| `realpath_cache_size` | `8M` | Default: 4096K |
| `opcache.memory_consumption` | `512` | Default: 128 |
| `opcache.interned_strings_buffer` | `64` | Default: 8 |
| `opcache.max_accelerated_files` | `30000` | Default: 10000 |
| `opcache.enable_file_override` | `1` | Default: 0 |
| `opcache.validate_timestamps` | `1` (dev) / `0` (prod) | Disabled in prod via `99_production.ini` |
| `apc.shm_size` | `64M` | Default: 32M |

### Dynamic Settings (Environment Variables)

Set via env vars at container startup. Template files processed by `ep` (envplate).

| Env Var | Default | PHP Setting | `php/*` images | `druidfi/app` |
|---------|---------|-------------|:--------------:|:-------------:|
| `PHP_MEMORY_LIMIT` | `512M` | `memory_limit` | ✓ | ✓ |
| `PHP_POST_MAX_SIZE` | `32M` | `post_max_size` | ✓ | ✓ |
| `PHP_UPLOAD_MAX_FILESIZE` | `32M` | `upload_max_filesize` | ✓ | ✓ |
| `PHP_MAX_EXECUTION_TIME` | `180` | `max_execution_time` | — | ✓ |
| `PHP_MAX_INPUT_VARS` | `2000` | `max_input_vars` | — | ✓ |
| `PHP_DISPLAY_ERRORS` | `On` | `display_errors` | — | ✓ |
| `PHP_SENDMAIL_PATH` | `msmtp -t` / `sendmail -S host.docker.internal:1025 -t` | `sendmail_path` | ✓ | ✓ |

### Xdebug

Disabled by default. Set `XDEBUG_ENABLE=true` to enable at container startup.

| Setting | Value |
|---------|-------|
| `xdebug.mode` | `debug` |
| `xdebug.client_host` | `host.docker.internal` |
| `xdebug.idekey` | `PHPSTORM` |
| `xdebug.log` | `/tmp/xdebug.log` |

## PHP Extensions

Extensions accumulate across image layers (`php` → `php-fpm` → `drupal` → `drupal-web`). `druidfi/app` builds on the official `php:fpm-alpine` base and uses `mlocati/php-extension-installer`.

| Extension | Type | `druidfi/php` | `druidfi/php-fpm` | `druidfi/drupal` | `druidfi/drupal-web` | `druidfi/app` |
|-----------|------|:-------------:|:-----------------:|:----------------:|:--------------------:|:-------------:|
| curl | core | ✓ | ✓ | ✓ | ✓ | ✓ |
| fileinfo | core | ✓ | ✓ | ✓ | ✓ | ✓ |
| iconv | core (gnu-libiconv) | ✓ | ✓ | ✓ | ✓ | ✓ |
| mbstring | core | ✓ | ✓ | ✓ | ✓ | ✓ |
| opcache | core | ✓ | ✓ | ✓ | ✓ | ✓ |
| openssl | core | ✓ | ✓ | ✓ | ✓ | ✓ |
| phar | core | ✓ | ✓ | ✓ | ✓ | ✓ |
| session | core | ✓ | ✓ | ✓ | ✓ | ✓ |
| zip | core | ✓ | ✓ | ✓ | ✓ | ✓ |
| apcu | PECL | ✓ | ✓ | ✓ | ✓ | ✓ |
| imagick | PECL | ✓ | ✓ | ✓ | ✓ | ✓ |
| redis | PECL | ✓ | ✓ | ✓ | ✓ | ✓ |
| uploadprogress | PECL | ✓ | ✓ | ✓ | ✓ | ✓ |
| xdebug | PECL | ✓ | ✓ | ✓ | ✓ | ✓ |
| bcmath | core | — | — | ✓ | ✓ | ✓ |
| ctype | core | — | — | ✓ | ✓ | ✓ |
| dom | core | — | — | ✓ | ✓ | ✓ |
| exif | core | — | — | ✓ | ✓ | ✓ |
| gd | core | — | — | ✓ | ✓ | ✓ |
| intl | core | — | — | ✓ | ✓ | — |
| pdo | core | — | — | ✓ | ✓ | ✓ |
| pdo_mysql | core | — | — | ✓ | ✓ | ✓ |
| simplexml | core | — | — | ✓ | ✓ | ✓ |
| soap | core | — | — | ✓ | ✓ | — |
| sockets | core | — | — | ✓ | ✓ | ✓ |
| sodium | core | — | — | ✓ | ✓ | ✓ |
| tokenizer | core | — | — | ✓ | ✓ | ✓ |
| xml | core | — | — | ✓ | ✓ | ✓ |
| xmlreader | core | — | — | ✓ | ✓ | ✓ |
| xmlwriter | core | — | — | ✓ | ✓ | ✓ |
| igbinary | PECL | — | — | ✓ | ✓ | ✓ |

> PHP 8.5 omits `opcache` (not yet in Alpine edge/testing). `intl` and `soap` are absent in `druidfi/app` — not in the official `php:fpm-alpine` base and not explicitly installed. `igbinary` enables binary serialization for the Redis/Valkey phpredis extension (used with the Drupal redis module).

## Installed Binaries

| Binary | Source | `druidfi/php` | `druidfi/php-fpm` | `druidfi/drupal` | `druidfi/drupal-web` | `druidfi/app` |
|--------|--------|:-------------:|:-----------------:|:----------------:|:--------------------:|:-------------:|
| `php` | Alpine apk / official base | ✓ | ✓ | ✓ | ✓ | ✓ |
| `composer` | `composer/composer:2.9-bin` | ✓ | ✓ | ✓ | ✓ | ✓ |
| `ep` | `amazeeio/envplate:26.3.0` | ✓ | ✓ | ✓ | ✓ | ✓ |
| `entrypoint` | `rootfs/usr/local/bin/` | ✓ | ✓ | ✓ | ✓ | ✓ |
| `fix-permissions` | `rootfs/usr/local/bin/` | ✓ | ✓ | ✓ | ✓ | ✓ |
| `bash` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `curl` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `git` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `make` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `msmtp` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `ssmtp` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `nano` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `tar` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `tini` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `fastfetch` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `patch` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `unzip` | Alpine apk | ✓ | ✓ | ✓ | ✓ | ✓ |
| `sudo` | Alpine apk | ✓ | ✓ | ✓ | ✓ | — |
| `doas` | Alpine apk | — | — | — | — | ✓ |
| `php-fpm` | Alpine apk / official base | — | ✓ | ✓ | ✓ | ✓ |
| `openssh` / `openssh-client` | Alpine apk | — | — | ✓ | ✓ | ✓ |
| `rsync` | Alpine apk | — | — | ✓ | ✓ | ✓ |
| `mariadb-client` | Alpine apk | — | — | ✓ | ✓ | ✓ |
| `install-php-extensions` | `mlocati/php-extension-installer` | — | — | — | — | ✓ |
| `nginx` | Alpine apk | — | — | — | ✓ | ✓ |
| `gdpr-dump` | GitHub releases (Smile-SA) | — | — | — | ✓ | ✓ |

## Certificates

Installed to `/opt/ssl/` in all images (from `rootfs/opt/ssl/` in the repo).

| File | `druidfi/php` | `druidfi/php-fpm` | `druidfi/drupal` | `druidfi/drupal-web` | `druidfi/app` | Purpose |
|------|:-------------:|:-----------------:|:----------------:|:--------------------:|:-------------:|---------|
| `DigiCertGlobalRootCA.crt.pem` | ✓ | ✓ | ✓ | ✓ | ✓ | Azure MySQL Flexible Server |
