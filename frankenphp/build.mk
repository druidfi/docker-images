BAKE_FLAGS := --pull --no-cache --push

PHONY += frankenphp-bake-all
frankenphp-bake-all: ## Bake all FrankenPHP images
	@docker buildx bake -f frankenphp/docker-bake.hcl $(BAKE_FLAGS)

PHONY += frankenphp-bake-print
frankenphp-bake-print: BAKE_FLAGS := --print
frankenphp-bake-print: frankenphp-bake-all ## Print bake plan for FrankenPHP images

PHONY += frankenphp-bake-local
frankenphp-bake-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
frankenphp-bake-local: frankenphp-bake-all run-frankenphp-tests ## Bake all FrankenPHP images locally

PHONY += frankenphp-bake-test
frankenphp-bake-test: BAKE_FLAGS := --pull --progress plain --no-cache
frankenphp-bake-test: frankenphp-bake-all run-frankenphp-tests ## CI test for FrankenPHP images

PHONY += run-frankenphp-tests
run-frankenphp-tests:
	$(call step,Run tests in druidfi/frankenphp:1.6.2-php8.3)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/frankenphp:1.6.2-php8.3 /app/scripts/tests_symfony.sh
	$(call step,Run tests in druidfi/frankenphp:1.6.2-php8.4)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/frankenphp:1.6.2-php8.4 /app/scripts/tests_symfony.sh

PHONY += frankenphp-update
frankenphp-update:
	@frankenphp/update.sh
