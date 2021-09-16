#
# TEST TARGETS
#

PHONY += test-php-fpm
test-php-fpm: TAG := 7.3-fpm
test-php-fpm: ## Test PHP-FPM images
	$(call step,PHP -v FROM druidfi/php:$(TAG))
	docker run --rm -it --user=druid druidfi/php:$(TAG) php -v

PHONY += test-images
test-images: PHP := 7.3
test-images: ## Test images
	$(call step,PHP -v FROM druidfi/drupal:$(PHP))
	docker run --rm -it --user=root druidfi/drupal:$(PHP) php -v
	$(call step,Nginx default.conf content FROM druidfi/drupal:$(PHP)-web)
	docker run --rm -it --user=root druidfi/drupal:$(PHP)-web cat /etc/nginx/conf.d/default.conf

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
example-drupal:
	$(call step,Setup example Drupal setup with Nginx and PHP containers)
	@(cd examples/drupal-separate-services && docker-compose down -v && docker-compose up -d --remove-orphans)
	$(call step,See the example site: https://example-drupal.docker.so)

PHONY += test-wp
test-wp:
	$(call step,PHP -v FROM druidfi/wordpress:7.3)
	docker run --rm -it --user=root druidfi/wordpress:7.3 php -v
	docker run --rm -it --user=root druidfi/wordpress:7.3 nginx -T
