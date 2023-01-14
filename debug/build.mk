BAKE_FLAGS := --pull --no-cache --push

PHONY += debug-bake-all
debug-bake-all: ## Bake all Symfony images
	BUILDX_EXPERIMENTAL=1 PHP81_MINOR=$(call get_php_minor,8.1) PHP82_MINOR=$(call get_php_minor,8.2) \
		docker buildx bake -f debug/docker-bake.hcl $(BAKE_FLAGS)

PHONY += debug-bake-print
debug-bake-print: BAKE_FLAGS := --print
debug-bake-print: debug-bake-all

PHONY += debug-bake-local
debug-bake-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
debug-bake-local: debug-bake-all run-debug-tests ## Bake all Symfony images locally

PHONY += debug-bake-web
debug-bake-web: BAKE_FLAGS := symfony-web-variants --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
debug-bake-web: debug-bake-all

PHONY += run-debug-tests
run-debug-tests:
	$(call step,Run tests in debug/symfony-web:php-8.1)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts debug/symfony-web:php-8.1 /app/scripts/tests_symfony.sh
	$(call step,Run tests in debug/symfony-web:php-8.2)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts debug/symfony-web:php-8.2 /app/scripts/tests_symfony.sh
