#
# PUSH TARGETS
#

PHONY += php-version-checker
php-version-checker: PHP_73_IMG := druidfi/drupal:7.3
php-version-checker: PHP_74_IMG := druidfi/drupal:7.4
php-version-checker:
	$(eval PHP_73_MINOR_TAG := $(shell docker run --rm -it $(PHP_73_IMG) bash -c "php -v | grep ^PHP | cut -d' ' -f2"))
	@test $(PHP_73_MINOR_TAG) || (echo "PHP_73_MINOR_TAG not set! Have you build PHP images?" && exit 1)
	$(eval PHP_74_MINOR_TAG := $(shell docker run --rm -it $(PHP_74_IMG) bash -c "php -v | grep ^PHP | cut -d' ' -f2"))
	@test $(PHP_74_MINOR_TAG) || (echo "PHP_74_MINOR_TAG not set! Have you build PHP images?" && exit 1)

PHONY += push-all
push-all: php-version-checker \
		  push-php \
		  push-drupal push-drupal-db push-drupal-qa \
		  push-nginx push-node push-misc ## Push all images to Docker Hub

PHONY += push-base
push-base: ## Push all base images to Docker Hub
	docker push druidfi/base:alpine$(ALPINE_VERSION)

PHONY += push-php-pecl
push-php-pecl: ## Push all PHP Pecl images to Docker Hub
	docker push druidfi/php-pecl:uploadprogress-7.3
	docker push druidfi/php-pecl:uploadprogress-7.4
	docker tag druidfi/php-pecl:uploadprogress-7.3 druidfi/php-pecl:uploadprogress-$(PHP_73_MINOR_TAG)
	docker tag druidfi/php-pecl:uploadprogress-7.4 druidfi/php-pecl:uploadprogress-$(PHP_74_MINOR_TAG)
	docker push druidfi/php-pecl:uploadprogress-$(PHP_73_MINOR_TAG)
	docker push druidfi/php-pecl:uploadprogress-$(PHP_74_MINOR_TAG)

PHONY += push-php
push-php: php-version-checker ## Push all PHP images to Docker Hub
	$(call step,Push all PHP images)
	docker push druidfi/php:7.3
	docker push druidfi/php:7.4
	docker push druidfi/php:7.3-fpm
	docker push druidfi/php:7.4-fpm
	$(call step,Tag and push PHP minor versions for PHP images)
	docker tag druidfi/php:7.3 druidfi/php:$(PHP_73_MINOR_TAG)
	docker tag druidfi/php:7.4 druidfi/php:$(PHP_74_MINOR_TAG)
	docker tag druidfi/php:7.3-fpm druidfi/php:$(PHP_73_MINOR_TAG)-fpm
	docker tag druidfi/php:7.4-fpm druidfi/php:$(PHP_74_MINOR_TAG)-fpm
	docker push druidfi/php:$(PHP_73_MINOR_TAG)
	docker push druidfi/php:$(PHP_74_MINOR_TAG)
	docker push druidfi/php:$(PHP_73_MINOR_TAG)-fpm
	docker push druidfi/php:$(PHP_74_MINOR_TAG)-fpm

PHONY += push-drupal
push-drupal: php-version-checker ## Push all Drupal images to Docker Hub
	$(call step,Push all Drupal images)
	docker push druidfi/drupal:7.3
	docker push druidfi/drupal:7.4
	docker push druidfi/drupal:7.3-web
	docker push druidfi/drupal:7.4-web
	docker push druidfi/drupal:7.3-test || true
	$(call step,Tag and push PHP minor versions for Drupal images)
	docker tag druidfi/drupal:7.3 druidfi/drupal:$(PHP_73_MINOR_TAG)
	docker tag druidfi/drupal:7.4 druidfi/drupal:$(PHP_74_MINOR_TAG)
	docker tag druidfi/drupal:7.3-web druidfi/drupal:$(PHP_73_MINOR_TAG)-web
	docker tag druidfi/drupal:7.4-web druidfi/drupal:$(PHP_74_MINOR_TAG)-web
	docker tag druidfi/drupal:7.3-test druidfi/drupal:$(PHP_73_MINOR_TAG)-test || true
	docker push druidfi/drupal:$(PHP_73_MINOR_TAG)
	docker push druidfi/drupal:$(PHP_74_MINOR_TAG)
	docker push druidfi/drupal:$(PHP_73_MINOR_TAG)-web
	docker push druidfi/drupal:$(PHP_74_MINOR_TAG)-web
	docker push druidfi/drupal:$(PHP_73_MINOR_TAG)-test || true

PHONY += push-drupal-db
push-drupal-db: ## Push all Drupal database images to Docker Hub
	docker push druidfi/db:mysql5.7-drupal
	docker push druidfi/db:mysql8.0-drupal

PHONY += push-drupal-qa
push-drupal-qa: ## Push all Drupal QA images to Docker Hub
	docker push druidfi/drupal-qa:8
	docker push druidfi/drupal-qa:7

PHONY += push-nginx
push-nginx: ## Push all Nginx images to Docker Hub
	docker push druidfi/nginx:$(NGINX_STABLE_VERSION)
	docker push druidfi/nginx:$(NGINX_STABLE_VERSION)-drupal

PHONY += push-node
push-node: ## Push all Node images to Docker Hub
	docker push druidfi/node:8
	docker push druidfi/node:10
	docker push druidfi/node:12
	docker push druidfi/node:14

PHONY += push-misc
push-misc: ## Push all other images to Docker Hub
	docker push druidfi/curl:alpine$(ALPINE_VERSION)
	docker push druidfi/dnsmasq:alpine$(ALPINE_VERSION)
	docker push druidfi/saml-idp:$(SIMPLESAMLPHP_VERSION)
	docker push druidfi/ssh-agent:alpine$(ALPINE_VERSION)
	docker push druidfi/varnish:6-drupal
