include $(PROJECT_DIR)/make/build/*.mk

PHONY += build-all
build-all: build-all-nginx build-all-php build-all-db build-all-misc build-all-node clean-up ## Build all images

PHONY += build-all-base
build-all-base: build-base-3.12 ## Build all base images

PHONY += build-all-nginx
build-all-nginx: build-nginx ## Build all Nginx images

PHONY += build-all-php
build-all-php: build-all-php-73 build-all-php-74 build-qa-toolset ## Build all PHP images (7.3, 7.4)

PHONY += build-all-php-73
build-all-php-73: PHP_SHORT_VERSION := 73
build-all-php-73: build-base-3.12 build-pecl-7.3 build-php-7.3 build-drupal-7.3 build-test-drupal-7.3 ## Build all PHP 7.3 images

PHONY += build-all-php-74
build-all-php-74: PHP_SHORT_VERSION := 74
build-all-php-74: build-base-3.12 build-pecl-7.4 build-php-7.4 build-drupal-7.4 build-test-drupal-7.4 ## Build all PHP 7.4 images

PHONY += build-all-db
build-all-db: build-db-5.7 build-db-8.0 ## Build all database images

PHONY += build-all-misc
build-all-misc: build-curl build-dnsmasq build-saml-idp build-varnish ## Build all misc images

PHONY += build-all-node
build-all-node: build-node-8 build-node-10 build-node-12 build-node-14 ## Build all Node LTS images (8, 10, 12, 14)

PHONY += build-all-test
build-all-test: build-test-drupal-7.3

#
# BUILD TARGETS
#

PHONY += build-base-init-%
build-base-init-%: ## build base-init images
	$(call step,Build druidfi/base-init:alpine$*)
	$(DBC) __base-init -t druidfi/base-init:alpine$* --build-arg ALPINE_VERSION=$*

PHONY += build-base-%
build-base-%: build-base-init-% ## Build base images
	$(call step,Build druidfi/base:alpine$*)
	$(DBC) --no-cache --force-rm base -t druidfi/base:alpine$* \
		--build-arg ALPINE_VERSION=$*

PHONY += build-pecl-%
build-pecl-%: ## Build pecl extensions
	$(call step,Build druidfi/php-pecl:uploadprogress-$*)
	$(DBC) --no-cache --force-rm php/pecl/uploadprogress -t druidfi/php-pecl:uploadprogress-$* \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		--build-arg PHP_SHORT_VERSION=$(PHP_SHORT_VERSION)

PHONY += build-php-%
build-php-%: ## Build PHP and PHP-FPM images
	$(call step,Build druidfi/php:$*)
	$(DBC) --no-cache --force-rm php/base -t druidfi/php:$* \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
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
	$(call step,Build druidfi/nginx:$(NGINX_STABLE_VERSION))
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

PHONY += build-wp
build-wp: ## Build Wordpress images
	$(call step,Build druidfi/wordpress)
	$(DBC) wp -t druidfi/wordpress:7.3 --target baseline \
		--build-arg PHP_VERSION=7.3 \
		--build-arg PHP_SHORT_VERSION=$(PHP_SHORT_VERSION) \
		--build-arg NGINX_VERSION=$(NGINX_STABLE_VERSION)

PHONY += build-qa-toolset
build-qa-toolset: PHP_VERSION := 7.3
build-qa-toolset: ## Build Drupal QA toolset image
	$(call step,Build druidfi/drupal-qa:8)
	$(DBC) --no-cache --force-rm drupal/qa -t druidfi/drupal-qa:8 \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg DRUPAL_VERSION=8
	$(call step,Build druidfi/drupal-qa:7)
	$(DBC) --no-cache --force-rm drupal/qa -t druidfi/drupal-qa:7 \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg DRUPAL_VERSION=7
	$(call step,Build druidfi/qa:symfony)
	$(DBC) --no-cache --force-rm php/qa/symfony -t druidfi/qa:symfony \
		--build-arg PHP_VERSION=$(PHP_VERSION)

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

PHONY += clean-up
clean-up:
	$(call step,Remove images which are not used...)
	docker image rm alpine:$(ALPINE_VERSION) || true
	docker image rm druidfi/base-init:alpine$(ALPINE_VERSION) || true
	docker image rm druidfi/php-pecl:uploadprogress-7.3 || true
	docker image rm druidfi/php-pecl:uploadprogress-7.4 || true
