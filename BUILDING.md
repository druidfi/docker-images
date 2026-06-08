# Building Docker Images

## How Builds Work

### Nightly Builds (Default)

Images are rebuilt automatically every night at **02:00 UTC** via the [nightly-build workflow](.github/workflows/nightly-build.yml). This is the normal path — no human action required.

The nightly workflow:
1. Resolves the current PHP patch versions from Alpine packages (`bin/helper phpminor 8.x`)
2. Builds all image groups: PHP, Nginx, DB, FrankenPHP, Misc
3. Pushes all tags to both **Docker Hub** (`docker.io/druidfi/`) and **GHCR** (`ghcr.io/druidfi/`)

PHP patch version resolution is fully automatic — `docker.io/druidfi/php:8.4` always tracks the latest `8.4.x` available in Alpine without any manual version bumping.

### PHP Images (Primary)

The PHP group builds four image variants, each built on top of the previous:

```
druidfi/php          (CLI base)
  └── druidfi/php-fpm      (PHP-FPM server)
        ├── druidfi/drupal         (Drupal-specific FPM)
        └── druidfi/drupal-web     (Drupal FPM + Nginx combined)
```

Each variant is built for **both** `linux/amd64` and `linux/arm64`.

Tags follow this pattern (using 8.4 as example):

| Image | Tags |
|---|---|
| `druidfi/php` | `8.4`, `8.4.x`, `8`, `latest` |
| `druidfi/php-fpm` | `8.4`, `8.4.x`, `8`, `latest` |
| `druidfi/drupal` | `php-8.4`, `php-8.4.x`, `php-8`, `latest` |
| `druidfi/drupal-web` | `php-8.4`, `php-8.4.x`, `v8.4.x`, `php-8`, `latest` |

PHP 8.4 currently holds the `latest` and `8` tags. PHP 8.5 is built but not promoted to `latest`.

---

## Manual Builds

Use this process when you need to build and push images immediately — for example, a security patch that can't wait for the nightly run.

### Step 1 — Make changes (optional)

Edit files under `php/` as needed (e.g. `php/Dockerfile`). Skip if you just want to force a rebuild of the current state.

### Step 2 — Verify the build plan (optional)

```bash
make php-bake-print
```

Prints the full bake plan including resolved PHP patch versions (e.g. `8.4.22`) and all tags that will be applied. Useful to confirm versions before building.

### Step 3 — Local test build

```bash
make php-bake-local
```

Builds all PHP images for the current machine architecture only (no push). After the build, automatically runs the test suite against all three minor variants (8.3, 8.4, 8.5) using `tests/scripts/tests.sh`.

If tests pass, you're ready to push.

### Step 4 — Build and push

```bash
make php-bake-all
```

Builds multi-arch images (`linux/amd64` + `linux/arm64`) and pushes all tags to both Docker Hub and GHCR. Manages the buildx builder automatically (creates it before, destroys it after).

Requires Docker Hub credentials to be configured locally.

---

## Summary

| Scenario | Action |
|---|---|
| Regular image updates | Do nothing — nightly runs at 02:00 UTC |
| Security patch or forced rebuild | `make php-bake-local` → `make php-bake-all` |
| Verify versions before building | `make php-bake-print` |
| Trigger nightly for all image groups | Run workflow manually via GitHub Actions UI |
