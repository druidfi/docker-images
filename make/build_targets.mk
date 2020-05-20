PHONY += build-all
build-all: build-all-nginx build-all-php build-all-db build-all-misc build-all-node ## Build all images

PHONY += build-all-base
build-all-base: build-base-3.7 build-base-3.11 ## Build all base images

PHONY += build-all-nginx
build-all-nginx: build-nginx-1.17 ## Build all Nginx images

PHONY += build-all-php
build-all-php: build-all-php-71 build-all-php-73 build-qa-toolset ## Build all PHP images (7.1, 7.3)

PHONY += build-all-php-71
build-all-php-71: ALPINE_VERSION := 3.7
build-all-php-71: build-base-3.7 build-pecl-7.1 build-php-7.1 build-drupal-7.1 ## Build all PHP 7.1 images

PHONY += build-all-php-73
build-all-php-73: build-base-3.11 build-pecl-7.3 build-php-7.3 build-drupal-7.3 build-test-drupal-7.3 ## Build all PHP 7.3 images

PHONY += build-all-db
build-all-db: build-db-5.7 ## Build all database images

PHONY += build-all-misc
build-all-misc: build-curl build-dnsmasq build-saml-idp build-varnish ## Build all misc images

PHONY += build-all-node
build-all-node: build-node-8 build-node-10 build-node-12 ## Build all Node LTS images (8, 10, 12)

#
# BUILD TARGETS
#

PHONY += build-base-%
build-base-%: ## Build base image
	$(call step,Build druidfi/base:alpine$*)
	docker build --no-cache --force-rm base -t druidfi/base:alpine$* \
		--build-arg ALPINE_VERSION=$*

PHONY += build-pecl-%
build-pecl-%: ## Build pecl extensions
	$(call step,Build druidfi/php-pecl-uploadprogress:$*)
	docker build --no-cache --force-rm php/pecl/uploadprogress -t druidfi/php-pecl-uploadprogress:$* \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		--build-arg PHP_VERSION=$*

PHONY += build-php-%
build-php-%: ## Build PHP and PHP-FPM images
	$(call step,Build druidfi/php:$*)
	docker build --no-cache --force-rm php/base -t druidfi/php:$* --target baseline \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		--build-arg COMPOSER_VERSION=$(COMPOSER_VERSION) \
		--build-arg BUILD_DATE=$(BUILD_DATE)
	$(call step,Build druidfi/php:$*-fpm)
	docker build --no-cache --force-rm php/fpm -t druidfi/php:$*-fpm --target baseline \
		--build-arg PHP_VERSION=$* \
		--build-arg BUILD_DATE=$(BUILD_DATE)

PHONY += build-nginx-%
build-nginx-%: ## Build Nginx images
	$(call step,Build druidfi/nginx:$*)
	docker build --no-cache --force-rm nginx/base -t druidfi/nginx:$* \
		--build-arg NGINX_VERSION=$*
	$(call step,Build druidfi/nginx-drupal:$*)
	docker build --no-cache --force-rm nginx/drupal -t druidfi/nginx:$*-drupal \
		--build-arg NGINX_VERSION=$*

PHONY += build-drupal-%
build-drupal-%: ## Build Drupal images
	$(call step,Build druidfi/drupal:$*)
	docker build --no-cache --force-rm drupal/base -t druidfi/drupal:$* \
		--build-arg PHP_VERSION=$*
	$(call step,Build druidfi/drupal:$*-web)
	docker build --no-cache --force-rm drupal/web -t druidfi/drupal:$*-web --target baseline \
		--build-arg PHP_VERSION=$* \
		--build-arg NGINX_VERSION=1.17
#	$(call step,Build druidfi/drupal:$*-web-openshift)
#	docker build --no-cache --force-rm drupal/web-openshift -t druidfi/drupal:$*-web-openshift --target baseline \
#		--build-arg PHP_VERSION=$*

PHONY += build-wp
build-wp: ## Build Wordpress images
	$(call step,Build druidfi/wordpress)
	docker build wp -t druidfi/wordpress:7.3 --target baseline \
		--build-arg PHP_VERSION=7.3 \
		--build-arg NGINX_VERSION=1.17

PHONY += build-qa-toolset
build-qa-toolset: PHP_VERSION := 7.3
build-qa-toolset: ## Build Drupal QA toolset image
	$(call step,Build druidfi/drupal-qa:8)
	docker build --no-cache --force-rm drupal/qa -t druidfi/drupal-qa:8 \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg DRUPAL_VERSION=8
	$(call step,Build druidfi/drupal-qa:7)
	docker build --no-cache --force-rm drupal/qa -t druidfi/drupal-qa:7 \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg DRUPAL_VERSION=7

PHONY += build-rector
build-rector: PHP_VERSION := 7.3
build-rector: ## Build Drupal Rector image
	$(call step,Build druidfi/drupal-rector:latest)
	docker build --no-cache --force-rm drupal/rector -t druidfi/drupal-rector:latest \
		--build-arg PHP_VERSION=$(PHP_VERSION)

PHONY += build-test-drupal-%
build-test-drupal-%: ## Build Drupal test images
	$(call step,Build druidfi/drupal:$*-test)
	docker build --no-cache --force-rm drupal/test -t druidfi/drupal:$*-test \
		--build-arg PHP_VERSION=$* \
		--build-arg BUILD_DATE=$(BUILD_DATE)

PHONY += build-node-%
build-node-%: ## Build Node images
	$(call step,Build druidfi/node:$*)
	docker build --no-cache --force-rm node -t druidfi/node:$* \
		--build-arg NODE_VERSION=$*

PHONY += build-db-%
build-db-%: ## Build Database images
	$(call step,Build druidfi/db:mysql$*)
	docker build --no-cache --force-rm db/mysql -t druidfi/db:mysql$*-drupal \
		--build-arg MYSQL_VERSION=$*

#
# BUILD: Misc images
#

PHONY += build-curl
build-curl: ## Build Curl image
	docker build --no-cache --force-rm misc/curl -t druidfi/curl:alpine$(ALPINE_VERSION) \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-dnsmasq
build-dnsmasq: ## Build dnsmasq image
	docker build --no-cache --force-rm misc/dnsmasq -t druidfi/dnsmasq:alpine$(ALPINE_VERSION) \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-saml-idp
build-saml-idp: ## Build build-saml-idp image
	docker build --no-cache --force-rm misc/saml-idp -t druidfi/saml-idp:$(SIMPLESAMLPHP_VERSION) \
		--build-arg SIMPLESAMLPHP_VERSION=$(SIMPLESAMLPHP_VERSION)

PHONY += build-ssh-agent
build-ssh-agent: ## Build ssh-agent image
	docker build --no-cache --force-rm misc/ssh-agent -t druidfi/ssh-agent:alpine$(ALPINE_VERSION)

PHONY += build-varnish
build-varnish: ## Build Varnish image
	$(call step,Build druidfi/varnish:6-drupal)
	docker build --no-cache --force-rm misc/varnish -t druidfi/varnish:6-drupal
