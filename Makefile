PHONY :=

ALPINE_VERSION := 3.10
COMPOSER_VERSION := 1.9.1

PHONY += help
help: ## List all make commands
	$(call step,Available make commands:)
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort

PHONY += build-all
build-all: build-php build-nginx-1.17 build-db ## Build all images

PHONY += build-php
build-php: build-php-71 build-php-73  ## Build all PHP images

PHONY += build-php-71
build-php-71: ALPINE_VERSION := 3.7
build-php-71: build-base-3.7 build-php-fpm-7.1 build-drupal-7.1 ## Build all PHP 7.1 images

PHONY += build-php-73
build-php-73: build-base-3.10 build-php-fpm-7.3 build-drupal-7.3 build-test-drupal-7.3 ## Build all PHP 7.3 images

PHONY += build-db
build-db: build-db-5.7 ## Build all database images

#
# BUILD TARGETS
#

PHONY += build-base-%
build-base-%: ## Build base image
	$(call step,Build druidfi/base:alpine$*)
	docker build --force-rm base -t druidfi/base:alpine$* \
		--build-arg ALPINE_VERSION=$*

PHONY += build-php-fpm-%
build-php-fpm-%: ## Build PHP-FPM images
	$(call step,Build druidfi/php:$*-fpm)
	docker build --no-cache --force-rm php/fpm -t druidfi/php:$*-fpm --target baseline \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		--build-arg PHP_VERSION=$* \
		--build-arg COMPOSER_VERSION=$(COMPOSER_VERSION)

PHONY += build-nginx-%
build-nginx-%: ## Build Nginx images
	$(call step,Build druidfi/nginx:$*)
	docker build --force-rm nginx/base -t druidfi/nginx:$* \
		--build-arg NGINX_VERSION=$*
	$(call step,Build druidfi/nginx-drupal:$*)
	docker build --force-rm nginx/drupal -t druidfi/nginx:$*-drupal \
		--build-arg NGINX_VERSION=$*

PHONY += build-drupal-%
build-drupal-%: ## Build Drupal images
	$(call step,Build druidfi/drupal:$*)
	docker build --force-rm drupal/base -t druidfi/drupal:$* \
		--build-arg PHP_VERSION=$*
	$(call step,Build druidfi/drupal:$*-web)
	docker build --force-rm drupal/web -t druidfi/drupal:$*-web --target baseline \
		--build-arg PHP_VERSION=$* \
		--build-arg NGINX_VERSION=1.17
	$(call step,Build druidfi/drupal:$*-web-openshift)
	docker build --force-rm drupal/web-openshift -t druidfi/drupal:$*-web-openshift --target baseline \
		--build-arg PHP_VERSION=$*

PHONY += build-test-drupal-%
build-test-drupal-%: ## Build Drupal test images
	$(call step,Build druidfi/drupal:$*-test)
	docker build --force-rm drupal/test -t druidfi/drupal:$*-test \
		--build-arg PHP_VERSION=$*

PHONY += build-db-%
build-db-%: ## Build Database images
	$(call step,Build druidfi/db:mysql$*)
	docker build --force-rm db/mysql5 -t druidfi/db:mysql$*-drupal \
		--build-arg MYSQL_VERSION=$*

#
# TEST TARGETS
#

PHONY += test-php-fpm
test-php-fpm: TAG := 7.3-fpm-alpine3.10
test-php-fpm: ## Test PHP-FPM images
	$(call step,PHP -v FROM druidfi/php:$(TAG))
	docker run --rm -it --user=root druidfi/php:$(TAG) php -v

PHONY += test-images
test-images: PHP := 7.3
test-images: ## Test images
	$(call step,PHP -v FROM druidfi/drupal:$(PHP))
	docker run --rm -it --user=root druidfi/drupal:$(PHP) php -v
	$(call step,Nginx default.conf content FROM druidfi/drupal-web:$(PHP))
	docker run --rm -it --user=root druidfi/drupal-web:$(PHP) cat /etc/nginx/conf.d/default.conf
	$(call step,MySQL/MariaDB version FROM druidfi/drupal-all:$(PHP))
	docker run --rm -it --user=root druidfi/drupal-all:$(PHP) mysql -V

PHONY += test-drupal-running
test-drupal-running:
	$(call step,Run drupal-test container)
	cd tests/drupal-test/ && docker-compose down -v && docker-compose up -d --remove-orphans

PHONY += example-drupal
example-drupal:
	cd examples/drupal-separate-services && docker-compose down -v && docker-compose up -d --remove-orphans

#
# SHELL TARGETS
#

HOST := test.druid.fi

PHONY += shell-base
shell-base: ## Login to base container
	docker run --rm -it --user=druid --hostname $(HOST) druidfi/base:alpine3.10 bash

PHONY += shell-php-fpm
shell-php-fpm: IMG := php
shell-php-fpm: TAG := 7.3-fpm
shell-php-fpm: ## Login to PHP-FPM container
	docker run --rm -it --user=druid --hostname $(HOST) druidfi/$(IMG):$(TAG) bash

PHONY += shell-drupal
shell-drupal: IMG := drupal
shell-drupal: TAG := 7.3
shell-drupal: ## Login to Drupal container
	docker run --rm -it --user=druid --hostname $(HOST) druidfi/$(IMG):$(TAG) bash

#
# PUSH TARGETS
#

push-all: ## Push all images to Docker Hub
	docker push druidfi/base:alpine3.7
	docker push druidfi/base:alpine3.10
	docker push druidfi/php:7.1-fpm
	docker push druidfi/php:7.3-fpm
	docker push druidfi/drupal:7.1
	docker push druidfi/drupal:7.1-web
	docker push druidfi/drupal:7.3
	docker push druidfi/drupal:7.3-web
	docker push druidfi/drupal:7.3-web-openshift
	docker push druidfi/drupal:7.3-test
	docker push druidfi/nginx:1.17
	docker push druidfi/nginx:1.17-drupal
	docker push druidfi/db:mysql5.7-drupal

define step
	@printf "\n\e[0;33m${1}\e[0m\n\n"
endef

.PHONY: $(PHONY)
