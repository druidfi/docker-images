#BUILD_TARGETS += build-all-php build-qa-toolset

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

PHONY += test-all-php-base
test-all-php-base: test-php-base-7.3 test-php-base-7.4 test-php-base-8.0 ## Build all PHP base images

PHONY += test-php-base-%
test-php-base-%:
	$(call step,Run tests in druidfi/php:$*)
	@docker pull --quiet druidfi/php:$*
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/php:$* /app/scripts/tests.sh
