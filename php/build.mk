BAKE_FLAGS := --pull --no-cache --push

PHONY += --php-bake
--php-bake:
	@PHP83_MINOR=$(call get_php_minor,8.3) PHP84_MINOR=$(call get_php_minor,8.4) PHP85_MINOR=$(call get_php_minor,8.5) \
		docker buildx bake -f php/docker-bake.hcl $(BAKE_FLAGS)

PHONY += php-bake-all
php-bake-all: buildx-create --php-bake buildx-destroy ## Bake all PHP images

PHONY += php-bake-print
php-bake-print: BAKE_FLAGS := --print
php-bake-print: --php-bake ## Print bake plan for PHP images

PHONY += php-bake-local
php-bake-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
php-bake-local: --php-bake run-php-tests ## Bake all PHP images locally

PHONY += php-bake-test
php-bake-test: BAKE_FLAGS := --pull --progress plain --no-cache
php-bake-test: --php-bake run-php-tests ## CI test for PHP images

PHONY += run-php-tests
run-php-tests:
	@for v in $(PHP_VERSIONS); do \
		printf "\n\e[0;33mRun tests in ghcr.io/druidfi/drupal-web:php-$$v\e[0m\n\n"; \
		docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts ghcr.io/druidfi/drupal-web:php-$$v /app/scripts/tests.sh || exit 1; \
	done
