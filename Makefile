PHONY :=

PHONY += build-all
build-all: build-base build-php-fpm ## Build all PHP images

PHONY += build-base
build-base: TAG := alpine-3.10
build-base: ## Build base image
	docker build --force-rm base -t druidfi/base:alpine3.10 \
		--build-arg ALPINE_VERSION=3.10

PHONY += build-php-fpm
build-php-fpm: ## Build PHP-FPM images
	docker build --force-rm php-fpm -t druidfi/php:7.3-fpm-alpine3.10 \
		--build-arg ALPINE_VERSION=3.10 --build-arg PHP_VERSION=7.3 --build-arg COMPOSER_VERSION=1.9
#	docker build --force-rm php-fpm -t druidfi/php:7.4.0RC3-fpm-alpine3.10 \
#		--build-arg ALPINE_VERSION=3.10 --build-arg PHP_VERSION=7.4.0RC3 --build-arg COMPOSER_VERSION=1.9

PHONY += build-drupal
build-drupal: ## Build Drupal images
	docker build --force-rm drupal -t druidfi/drupal:7.3-fpm-alpine3.10 \
    		--build-arg ALPINE_VERSION=3.10 --build-arg PHP_VERSION=7.3

PHONY += test-php-fpm
test-php-fpm: ## Test PHP-FPM images
	$(call step,PHP -v FROM druidfi/php:7.3-fpm-alpine3.10)
	docker run --rm -it --user=root druidfi/php:7.3-fpm-alpine3.10 php -v
#	docker run --rm -it --user=root druidfi/php:7.4.0RC3-fpm-alpine3.10 php -v

PHONY += shell-php-fpm
shell-php-fpm: ## Login to PHP-FPM container
	docker run --rm -it --user=druid druidfi/php:7.3-fpm-alpine3.10 sh

PHONY += shell-drupal
shell-drupal: TAG := 7.3-fpm-alpine3.10
shell-drupal: ## Login to Drupal container
	docker run --rm -it --user=druid druidfi/drupal:$(TAG) sh

define step
	@printf "\e[0;33m${1}\e[0m\n"
endef

.PHONY: $(PHONY)
