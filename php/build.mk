BAKE_FLAGS := --pull --no-cache

PHONY += bake-all-php
bake-all-php: ## Bake all PHP images (incl. Drupal)
	@ALPINE_VERSION=$(call get_alpine_version) ALPINE_VERSION_PREVIOUS=$(call get_alpine_version,3.12) \
	PHP73_MINOR=$(call get_php_minor,7.3) PHP74_MINOR=$(call get_php_minor,7.4) PHP80_MINOR=$(call get_php_minor,8.0) \
		docker buildx bake -f php/docker-bake.hcl $(BAKE_FLAGS)

PHONY += bake-php-print
bake-php-print: BAKE_FLAGS := --print
bake-php-print: bake-all-php

PHONY += bake-php-local
bake-php-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
bake-php-local: bake-all-php

PHONY += bake-php-test
bake-php-test: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH) --set *.target=test
bake-php-test: bake-all-php
