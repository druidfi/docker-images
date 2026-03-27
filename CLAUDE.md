# docker-images

See `/CLAUDE.md` for Druid.fi platform standards. This file documents this repository specifically.

## Purpose

Centralized Docker image repository for Druid Oy. Images are published to:
- Docker Hub: `docker.io/druidfi/*`
- GHCR: `ghcr.io/druidfi/*`

Used across all 40+ Druid projects via `druidfi/tools` Makefile framework.

**PHP images are the primary focus of this repo.** All other images (nginx, db, frankenphp, misc) are helpers or sidecars supporting PHP-based Drupal and Symfony projects.

## Common Commands

```bash
make help                   # List all targets
make buildx-create          # Create/use druid-buildx builder (required before buildx builds)
make buildx-destroy         # Remove druid-buildx builder (cleanup after builds)
make build-all              # Build all image groups

# Per-image-group targets
make php-bake-local         # Build PHP images locally (current arch only)
make php-bake-test          # CI test build (no push)
make php-bake-all           # Build + push to both registries (CI/CD use)
make php-bake-print         # Print build plan

# Same pattern for other groups:
make nginx-bake-local / nginx-bake-test / nginx-bake-all
make db-bake-local / db-bake-test / db-bake-all
make frankenphp-bake-local / frankenphp-bake-test / frankenphp-bake-all
make drupal-test-bake-all
make misc-bake-all / misc-bake-idp / misc-bake-localsolr

# Test environments
make test-drupal-running    # Start drupal-test compose
make shell-drupal           # Shell into drupal container
make run-php-tests          # Run PHP image tests
make run-frankenphp-tests   # Run FrankenPHP image tests
```

## Image Catalog

### PHP (`php/`) — Primary Images

| Image | Tags | Description |
|-------|------|-------------|
| `druidfi/php` | `8.3`, `8.3.x`, `8.4`, `8.4.x`, `8`, `latest` | PHP CLI base |
| `druidfi/php-fpm` | same pattern | PHP-FPM server |
| `druidfi/drupal` | `php-8.3`, `php-8.3.x`, `php-8.4`, `php-8`, `latest` | Drupal PHP-FPM |
| `druidfi/drupal-web` | `php-8.3`, `php-8.3.x`, `v8.3.x`, `php-8.4`, `latest` | Drupal FPM + Nginx combined |

PHP 8.5 images exist but are not marked `latest` — PHP 8.5 is not yet considered ready for Drupal projects.

#### PHP Extensions

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

> PHP 8.5 omits `opcache` (not yet in Alpine edge/testing). `intl` and `soap` are absent in `druidfi/app` — not in the official `php:fpm-alpine` base and not explicitly installed. `igbinary` is unique to `druidfi/app` and enables binary serialization for the Redis/Valkey phpredis extension.

#### Installed Binaries

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

#### Certificates

Installed to `/opt/ssl/` in all images.

| File | `druidfi/php` | `druidfi/php-fpm` | `druidfi/drupal` | `druidfi/drupal-web` | `druidfi/app` | Purpose |
|------|:-------------:|:-----------------:|:----------------:|:--------------------:|:-------------:|---------|
| `BaltimoreCyberTrustRoot.crt.pem` | ✓ | ✓ | ✓ | ✓ | ✓ | Azure MySQL (legacy) |
| `DigiCertGlobalRootG2.crt.pem` | ✓ | ✓ | ✓ | ✓ | ✓ | Azure PostgreSQL |
| `DigiCertGlobalRootCA.crt.pem` | ✓ | ✓ | ✓ | ✓ | ✓ | Azure MySQL Flexible Server |

### Helper & Sidecar Images

#### Nginx (`nginx/`)

| Image | Tags | Description |
|-------|------|-------------|
| `druidfi/nginx` | `1.28`, `stable`, `1.28-drupal`, `stable-drupal` | Stable Nginx |
| `druidfi/nginx` | `1.29`, `mainline`, `1.29-drupal`, `mainline-drupal` | Mainline Nginx |
| `druidfi/nginx` | `placeholder` | Placeholder page |

#### Database (`db/`)

| Image | Tags | Description |
|-------|------|-------------|
| `druidfi/mariadb` | `10.6-drupal[-lts]`, `10.11-drupal[-lts]`, `11.4-drupal[-lts]`, `latest` | MariaDB for Drupal |
| `druidfi/mysql` | `5.7-drupal`, `8.0-drupal[-lts]`, `8.4-drupal[-lts]`, `latest` | MySQL for Drupal |

Default credentials: user/pass/db = `drupal`, root password = `drupal`.

#### FrankenPHP (`frankenphp/`)

| Image | Tags | Description |
|-------|------|-------------|
| `druidfi/frankenphp` | `1.x.y-php8.4`, `1.x.y-php8.5`, `latest` | FrankenPHP embedded server |

#### Misc (`misc/`)

- `druidfi/s3-sync` - S3 backup sync utility
- `druidfi/saml-idp` - SimpleSAMLphp SAML Identity Provider
- `druidfi/solr` - Apache Solr for Drupal (`8-drupal`, `8.11-drupal`)
- `druidfi/curl` - Alpine curl utility

#### Test Images

- `druidfi/drupal-test:php-8.3`, `druidfi/drupal-test:php-8.4` - Pre-installed Drupal 10 with contrib modules

## Directory Structure

```
{image_dir}/
├── Dockerfile          # Multi-stage build definition
├── docker-bake.hcl    # Buildx bake config (tags, build args, targets)
├── build.mk           # Make targets (included by root Makefile)
└── rootfs/            # Files copied into image filesystem
    ├── etc/           # System config
    ├── usr/local/bin/ # Scripts/binaries
    └── entrypoints/   # Numbered startup scripts (00-99, run in order)
```

## Key Patterns

### Build System

Uses **Docker Buildx Bake** (`docker-bake.hcl`) for all images:
- Multi-architecture: `linux/amd64` + `linux/arm64`
- All tags (Docker Hub + GHCR) defined in bake config
- Local builds use current architecture only

### Dynamic Version Resolution

`bin/helper` script resolves exact versions at build time:
- `bin/helper alpineversion 3.23` → queries Docker Hub for latest `3.23.x` tag
- `bin/helper phpminor 8.4` → queries Alpine AportsBuild for latest PHP patch version

Called from `docker-bake.hcl` variable blocks and Makefile targets.

### Versioning

- `latest` tag always points to newest stable PHP major version (currently 8.4)
- Alpine base version: `3.23.x` (updated via Renovate or manual security patches)
- PHP patch versions resolved dynamically from Alpine packages

### OCI Labels

All images include standard labels:
```hcl
"org.opencontainers.image.url"     = "https://github.com/druidfi/docker-images"
"org.opencontainers.image.vendor"  = "Druid Oy"
"org.opencontainers.image.licenses" = "MIT"
```

### Standard Environment Variables

All images set:
```
KIND=druid-docker-image
APP_PATH=/app
DEFAULT_USER=druid
DEFAULT_USER_UID=1000
```

### User Setup

All images create a non-root `druid` user (UID 1000) with sudo access. Working directory is `/app`.

### Entrypoint

Uses **tini** for signal handling: `ENTRYPOINT ["/sbin/tini", "--", "entrypoint"]`

Numbered scripts in `rootfs/entrypoints/` execute in order (e.g., `15-xdebug.sh`, `19-php_ini.sh`, `20-php-fpm.sh`).

## CI/CD

GitHub Actions workflows in `.github/workflows/`:

| Workflow | Trigger | Action |
|----------|---------|--------|
| `php.yml` | Push/PR to `php/**` | PR: local build; main: build + push |
| `nginx.yml` | Push/PR to `nginx/**` | `nginx-bake-test` |
| `db.yml` | Push/PR to `db/**` | `db-bake-test` |
| `misc.yml` | Push/PR to `misc/**` | `misc-bake-test` |
| `nightly.yml` | Daily 02:00 UTC + manual | Build + push all images to both registries |

All CI builds use `--pull --no-cache`. Push only happens on main branch merges and nightly runs.

The nightly workflow requires two repository secrets: `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`.

## Adding a New Image Version

1. Update `docker-bake.hcl` - add new variable (e.g., `PHP85_MINOR`) and target group
2. Update `Dockerfile` - add new build stage if needed
3. Update `build.mk` - add local/test/all targets
4. Test locally: `make {image}-bake-local`
5. CI validates on PR, pushes on merge to main

## Example Usage in Projects

```yaml
# compose.yaml
services:
  web:
    image: druidfi/nginx:1.28-drupal
  app:
    image: druidfi/drupal:php-8.4
  db:
    image: druidfi/mariadb:11.4-drupal-lts
```
