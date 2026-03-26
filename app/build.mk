BAKE_FLAGS := --pull --no-cache --push

PHONY += --app-bake
--app-bake:
	@PHP83_MINOR=$(call get_php_fpm_minor,8.3) PHP84_MINOR=$(call get_php_fpm_minor,8.4) PHP85_MINOR=$(call get_php_fpm_minor,8.5) \
		docker buildx bake -f app/docker-bake.hcl $(BAKE_FLAGS)

PHONY += app-bake-all
app-bake-all: buildx-create --app-bake buildx-destroy ## Bake all APP images

PHONY += app-bake-print
app-bake-print: BAKE_FLAGS := --print
app-bake-print: --app-bake ## Print bake plan for App images

PHONY += app-bake-local
app-bake-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
app-bake-local: --app-bake run-app-tests ## Bake all App images locally

PHONY += app-bake-test
app-bake-test: BAKE_FLAGS := --pull --progress plain --no-cache
app-bake-test: --app-bake run-app-tests ## CI test for App images

PHONY += run-app-tests
run-app-tests:
	@for v in $(PHP_VERSIONS); do \
		printf "\n\e[0;33mRun tests in ghcr.io/druidfi/app:php-$$v\e[0m\n\n"; \
		docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts ghcr.io/druidfi/app:php-$$v /app/scripts/tests.sh || exit 1; \
	done
