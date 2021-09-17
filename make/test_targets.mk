#
# TEST TARGETS
#

PHONY += test-php-fpm
test-php-fpm: TAG := 7.3-fpm
test-php-fpm: ## Test PHP-FPM images
	$(call step,PHP -v FROM druidfi/php:$(TAG))
	docker run --rm -it --user=druid druidfi/php:$(TAG) php -v

PHONY += test-drupal-running
test-drupal-running:
	$(call step,Run drupal-test container)
	@(cd tests/drupal-test/ && docker-compose down -v && docker-compose up -d --remove-orphans)
	$(call step,See the example site: https://test-drupal.docker.so)

PHONY += test-wp-running
test-wp-running:
	$(call step,Run wp-test container)
	@(cd tests/wp-test/ && docker-compose down -v && docker-compose up -d --remove-orphans)
	$(call step,See the example site: https://test-wp.docker.so)

PHONY += example-drupal
example-drupal: ALPINE_VERSION := 3.14.2
example-drupal: PHP_VERSION := 7.4
example-drupal: PHP_SHORT_VERSION := 74
example-drupal:
	$(call step,Build base image with Alpine $(ALPINE_VERSION))
	@docker build -t druidfi/base:alpine-$(ALPINE_VERSION) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --target base base
	$(call step,Build base PHP $(PHP_VERSION) image)
	@docker build -t druidfi/php:$(PHP_VERSION) --build-arg PHP_SHORT_VERSION=$(PHP_SHORT_VERSION) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --target final php/base
	$(call step,Build base PHP-FPM $(PHP_VERSION) image)
	@docker build -t druidfi/php-fpm:$(PHP_VERSION) --build-arg PHP_SHORT_VERSION=$(PHP_SHORT_VERSION) --build-arg PHP_VERSION=$(PHP_VERSION) --build-arg BASE_IMAGE_NAME=druidfi/php --target final php/fpm
	$(call step,Build Drupal base image with PHP $(PHP_VERSION))
	@docker build -t druidfi/drupal:php-$(PHP_VERSION) --build-arg PHP_SHORT_VERSION=$(PHP_SHORT_VERSION) --build-arg PHP_VERSION=$(PHP_VERSION) --build-arg BASE_PHP_IMAGE_NAME=druidfi/php-fpm --target final drupal/base
	$(call step,Run tests against druidfi/drupal:$(PHP_VERSION))
	@docker run --rm -t -u druid -v $(CURDIR)/tests/scripts:/app/scripts druidfi/drupal:$(PHP_VERSION) /app/scripts/tests.sh
	$(call step,Raise up example Drupal setup with Nginx and PHP containers)
	@(cd examples/drupal-separate-services && docker-compose down -v && docker-compose up -d --remove-orphans)
	$(call step,See the example site: https://example-drupal.docker.so)

PHONY += test-wp
test-wp:
	$(call step,PHP -v FROM druidfi/wordpress:7.3)
	docker run --rm -it --user=root druidfi/wordpress:7.3 php -v
	docker run --rm -it --user=root druidfi/wordpress:7.3 nginx -T
