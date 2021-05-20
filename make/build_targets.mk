BUILD_TARGETS := build-all-base build-all-nginx build-all-php build-qa-toolset

include $(PROJECT_DIR)/make/build/*.mk

PHONY += build-all
build-all: $(BUILD_TARGETS) ## Build all images

PHONY += build-all-base
build-all-base: build-base-3.12.7 build-base-3.13.5 ## Build all Base images

PHONY += build-all-nginx
build-all-nginx: build-nginx ## Build all Nginx images

PHONY += build-all-php
build-all-php: build-all-php-73 build-all-php-74 build-all-php-80 ## Build all PHP images (7.3, 7.4, 8.0)

PHONY += build-all-php-73
build-all-php-73: PHP_SHORT_VERSION := 73
build-all-php-73: build-php-7.3 build-drupal-7.3 build-wp-7.3 ## Build all PHP 7.3 images

PHONY += build-all-php-74
build-all-php-74: PHP_SHORT_VERSION := 74
build-all-php-74: build-php-7.4 build-drupal-7.4 build-wp-7.4 ## Build all PHP 7.4 images

PHONY += build-all-php-80
build-all-php-80: PHP_SHORT_VERSION := 80
build-all-php-80: build-php-8.0 build-drupal-8.0 build-wp-8.0 ## Build all PHP 8.0 images

PHONY += build-all-test
build-all-test: build-test-drupal-7.3 build-test-drupal-7.4 build-test-drupal-8.0

#
# BUILD TARGETS
#

PHONY += build-base-%
build-base-%: ## Build base images
	$(call step,Build druidfi/base:alpine$*)
	$(DBC) --no-cache --force-rm base -t druidfi/base:alpine$* \
		--build-arg ALPINE_VERSION=$*

PHONY += build-php-%
build-php-%: ## Build PHP and PHP-FPM images
	$(call step,Build druidfi/php:$*)
	$(DBC) --no-cache --force-rm php/base -t druidfi/php:$* \
		--build-arg PHP_SHORT_VERSION=$(PHP_SHORT_VERSION) \
		--build-arg PHP_VERSION=$* \
		--build-arg BUILD_DATE=$(BUILD_DATE)
	$(call step,Build druidfi/php:$*-fpm)
	$(DBC) --no-cache --force-rm php/fpm -t druidfi/php:$*-fpm \
		--build-arg PHP_VERSION=$* \
		--build-arg PHP_SHORT_VERSION=$(PHP_SHORT_VERSION) \
		--build-arg BUILD_DATE=$(BUILD_DATE)

PHONY += build-nginx
build-nginx: ## Build Nginx images
	$(call step,Build druidfi/nginx:stable)
	$(DBC) --no-cache --force-rm nginx/base -t druidfi/nginx:$(NGINX_STABLE_VERSION) \
		--build-arg NGINX_VERSION=$(NGINX_STABLE_VERSION)
	$(call step,Build druidfi/nginx-drupal:$(NGINX_STABLE_VERSION))
	$(DBC) --no-cache --force-rm nginx/drupal -t druidfi/nginx:$(NGINX_STABLE_VERSION)-drupal \
		--build-arg NGINX_VERSION=$(NGINX_STABLE_VERSION)

PHONY += build-drupal-%
build-drupal-%: ## Build Drupal images
	$(call step,Build druidfi/drupal:$*)
	$(DBC) --no-cache --force-rm drupal/base -t druidfi/drupal:$* \
		--build-arg PHP_SHORT_VERSION=$(PHP_SHORT_VERSION) \
		--build-arg PHP_VERSION=$*
	$(call step,Build druidfi/drupal:$*-web)
	$(DBC) --no-cache --force-rm drupal/web -t druidfi/drupal:$*-web \
		--build-arg PHP_SHORT_VERSION=$(PHP_SHORT_VERSION) \
		--build-arg PHP_VERSION=$* \
		--build-arg NGINX_VERSION=$(NGINX_STABLE_VERSION)

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

PHONY += build-rector
build-rector: PHP_VERSION := 7.3
build-rector: ## Build Drupal Rector image
	$(call step,Build druidfi/drupal-rector:latest)
	$(DBC) --no-cache --force-rm drupal/rector -t druidfi/drupal-rector:latest \
		--build-arg PHP_VERSION=$(PHP_VERSION)

PHONY += build-test-drupal-%
build-test-drupal-%: ## Build Drupal test images
	$(call step,Build druidfi/drupal:$*-test)
	$(DBC) --no-cache --force-rm drupal/test -t druidfi/drupal:$*-test \
		--build-arg PHP_VERSION=$* \
		--build-arg BUILD_DATE=$(BUILD_DATE)
