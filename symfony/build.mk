SF_BAKE_FLAGS := --pull --no-cache --push --progress plain

PHONY += symfony-bake-all
symfony-bake-all: ## Bake all Symfony images
	PHP81_MINOR=$(call get_php_minor,8.1) PHP82_MINOR=$(call get_php_minor,8.2) \
		docker buildx bake -f symfony/docker-bake.hcl $(SF_BAKE_FLAGS)

PHONY += symfony-bake-print
symfony-bake-print: SF_BAKE_FLAGS := --print
symfony-bake-print: symfony-bake-all

PHONY += symfony-bake-local
symfony-bake-local: SF_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
symfony-bake-local: symfony-bake-all run-symfony-tests ## Bake all Symfony images locally

PHONY += symfony-bake-web
symfony-bake-web: SF_BAKE_FLAGS := symfony-web-variants --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
symfony-bake-web: symfony-bake-all

PHONY += run-symfony-tests
run-symfony-tests:
	$(call step,Run tests in druidfi/symfony-web:php-8.1)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/symfony-web:php-8.1 /app/scripts/tests_symfony.sh
	$(call step,Run tests in druidfi/symfony-web:php-8.2)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/symfony-web:php-8.2 /app/scripts/tests_symfony.sh
