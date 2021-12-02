BAKE_FLAGS := --pull --no-cache --push

PHONY += bake-all-php
bake-all-php: ## Bake all PHP images (incl. Drupal)
	@ALPINE_VERSION=$(call get_alpine_version) \
	PHP74_MINOR=$(call get_php_minor,7.4) PHP80_MINOR=$(call get_php_minor,8.0) PHP81_MINOR=$(call get_php_minor,8.1) \
		docker buildx bake -f php/docker-bake.hcl $(BAKE_FLAGS)

PHONY += bake-php-print
bake-php-print: BAKE_FLAGS := --print
bake-php-print: bake-all-php

PHONY += bake-php-local
bake-php-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
bake-php-local: bake-all-php run-php-tests

PHONY += bake-php-test
bake-php-test: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH) --set *.target=test
bake-php-test: bake-all-php

PHONY += run-php-tests
run-php-tests:
	$(call step,Run tests in druidfi/php:7.4)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/php:7.4 /app/scripts/tests.sh
	$(call step,Run tests in druidfi/php:8.0)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/php:8.0 /app/scripts/tests.sh
	$(call step,Run tests in druidfi/php:8.1)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/php:8.1 /app/scripts/tests.sh
