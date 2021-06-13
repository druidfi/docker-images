#BUILD_TARGETS += build-all-php build-qa-toolset

ALPINE_PLAIN := https://git.alpinelinux.org/aports/plain/community

PHONY += bake-all-php
bake-all-php: AP_312_PHP7 := $(ALPINE_PLAIN)/php7/APKBUILD\?h\=3.12-stable
bake-all-php: AP_313_PHP7 := $(ALPINE_PLAIN)/php7/APKBUILD\?h\=3.13-stable
bake-all-php: AP_313_PHP8 := $(ALPINE_PLAIN)/php8/APKBUILD\?h\=3.13-stable
bake-all-php: ## Bake all PHP images (7.3, 7.4, 8.0)
	$(eval PHP73_MINOR := $(shell curl -s $(AP_312_PHP7) | cat | grep -i "pkgver=" | cut -d "=" -f2))
	$(eval PHP74_MINOR := $(shell curl -s $(AP_313_PHP7) | cat | grep -i "pkgver=" | cut -d "=" -f2))
	$(eval PHP80_MINOR := $(shell curl -s $(AP_313_PHP8) | cat | grep -i "pkgver=" | cut -d "=" -f2))
	@cd php && PHP73_MINOR=$(PHP73_MINOR) PHP74_MINOR=$(PHP74_MINOR) PHP80_MINOR=$(PHP80_MINOR) \
		docker buildx bake --print --pull --push --progress plain

PHONY += build-all-php
build-all-php: build-all-php-73 build-all-php-74 build-all-php-80 ## Build all PHP images (7.3, 7.4, 8.0)

PHONY += build-all-php-73
build-all-php-73: PHP_SHORT_VERSION := 73
build-all-php-73: build-wp-7.3 ## Build all PHP 7.3 images

PHONY += build-all-php-74
build-all-php-74: PHP_SHORT_VERSION := 74
build-all-php-74: build-wp-7.4 ## Build all PHP 7.4 images

PHONY += build-all-php-80
build-all-php-80: PHP_SHORT_VERSION := 80
build-all-php-80: build-wp-8.0 ## Build all PHP 8.0 images

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
