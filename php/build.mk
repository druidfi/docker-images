BAKE_FLAGS := --pull --no-cache --push

PHONY += php-bake-all
php-bake-all: ## Bake all PHP images
	@PHP83_MINOR=$(call get_php_minor,8.3) PHP84_MINOR=$(call get_php_minor,8.4) \
		docker buildx bake -f php/docker-bake.hcl $(BAKE_FLAGS)

PHONY += php-bake-print
php-bake-print: BAKE_FLAGS := --print
php-bake-print: php-bake-all ## Print bake plan for PHP images

PHONY += php-bake-local
php-bake-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
php-bake-local: php-bake-all run-php-tests ## Bake all PHP images locally

PHONY += php-bake-test
php-bake-test: BAKE_FLAGS := --pull --progress plain --no-cache
php-bake-test: php-bake-all run-php-tests ## CI test for PHP images

PHONY += run-php-tests
run-php-tests:
	$(call step,Run tests in druidfi/drupal-web:php-8.3)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/drupal-web:php-8.3 /app/scripts/tests.sh
	$(call step,Run tests in druidfi/drupal-web:php-8.4)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/drupal-web:php-8.4 /app/scripts/tests.sh
