#BUILD_TARGETS += build-all-php build-qa-toolset

PHONY += bake-all-php
bake-all-php: ## Bake all PHP images (7.3, 7.4, 8.0)
	@cd php && ALPINE_VERSION=$(call get_alpine_version) ALPINE_VERSION_PREVIOUS=$(call get_alpine_version,3.12) \
	PHP73_MINOR=$(call get_php_minor,7.3) PHP74_MINOR=$(call get_php_minor,7.4) PHP80_MINOR=$(call get_php_minor,8.0) \
		docker buildx bake --pull --push

PHONY += build-all-wp
build-all-wp: build-wp-7.3 build-wp-7.4 build-wp-8.0 ## Build all WordPress images

PHONY += build-all-test
build-all-test: build-test-drupal-7.3 build-test-drupal-7.4 build-test-drupal-8.0

PHONY += build-wp-%
build-wp-%: ## Build Wordpress images
	$(call step,Build druidfi/wordpress:php-$*)
	$(DBC) --no-cache --force-rm wp -t druidfi/wordpress:php-$* \
		--build-arg PHP_SHORT_VERSION=$(PHP_SHORT_VERSION) \
		--build-arg PHP_VERSION=$*

PHONY += build-qa-toolset
build-qa-toolset: ## Build Drupal QA toolset image
	$(call step,Build druidfi/qa:php-7.3)
	$(DBC) --no-cache --force-rm php/qa -t druidfi/qa:php-7.3 \
		--build-arg PHP_VERSION=7.3 --build-arg PHP_SHORT_VERSION=73
	$(call step,Build druidfi/qa:php-7.4)
	$(DBC) --no-cache --force-rm php/qa -t druidfi/qa:php-7.4 \
		--build-arg PHP_VERSION=7.4 --build-arg PHP_SHORT_VERSION=74
	$(call step,Build druidfi/qa:php-8.0)
	$(DBC) --no-cache --force-rm php/qa -t druidfi/qa:php-8.0 \
		--build-arg PHP_VERSION=8.0 --build-arg PHP_SHORT_VERSION=80

PHONY += build-test-drupal-%
build-test-drupal-%: ## Build Drupal test images
	$(call step,Build druidfi/drupal:$*-test)
	$(DBC) --no-cache --force-rm drupal/test -t druidfi/drupal:$*-test \
		--build-arg PHP_VERSION=$* \
		--build-arg BUILD_DATE=$(BUILD_DATE)
