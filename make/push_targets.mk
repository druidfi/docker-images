#
# PUSH TARGETS
#

PHONY += push-all
push-all: push-base push-php push-drupal push-node push-misc ## Push all images to Docker Hub

PHONY += push-base
push-base: ## Push all base images to Docker Hub
	docker push druidfi/base:alpine3.7
	docker push druidfi/base:alpine3.11

PHONY += push-php
push-php: ## Push all PHP images to Docker Hub
	docker push druidfi/php-pecl-uploadprogress:7.1
	docker push druidfi/php-pecl-uploadprogress:7.3
	docker push druidfi/php:7.1
	docker push druidfi/php:7.3
	docker push druidfi/php:7.1-fpm
	docker push druidfi/php:7.3-fpm
	docker tag druidfi/php:7.1 druidfi/php:$(PHP_71_MINOR_TAG)
	docker tag druidfi/php:7.3 druidfi/php:$(PHP_73_MINOR_TAG)
	docker tag druidfi/php:7.1-fpm druidfi/php:$(PHP_71_MINOR_TAG)-fpm
	docker tag druidfi/php:7.3-fpm druidfi/php:$(PHP_73_MINOR_TAG)-fpm

PHONY += push-drupal
push-drupal: ## Push all Drupal images to Docker Hub
	docker push druidfi/drupal:7.1
	docker push druidfi/drupal:7.1-web
	docker push druidfi/drupal:7.3
	docker push druidfi/drupal:7.3-web
#	docker push druidfi/drupal:7.3-web-openshift
	docker push druidfi/drupal:7.3-test
	docker push druidfi/drupal-qa:8
	docker push druidfi/drupal-qa:7
	docker push druidfi/nginx:1.17-drupal
	docker push druidfi/db:mysql5.7-drupal
	docker push druidfi/db:mysql8.0-drupal

PHONY += push-node
push-node: ## Push all Node images to Docker Hub
	docker push druidfi/node:8
	docker push druidfi/node:10
	docker push druidfi/node:12

PHONY += push-misc
push-misc: ## Push all other images to Docker Hub
	docker push druidfi/nginx:1.17
	docker push druidfi/curl:alpine3.11
	docker push druidfi/varnish:6-drupal
	docker push druidfi/dnsmasq:alpine3.11
	docker push druidfi/saml-idp:$(SIMPLESAMLPHP_VERSION)
