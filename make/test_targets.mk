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

PHONY += test-wp
test-wp:
	$(call step,PHP -v FROM druidfi/wordpress:7.3)
	docker run --rm -it --user=root druidfi/wordpress:7.3 php -v
	docker run --rm -it --user=root druidfi/wordpress:7.3 nginx -T
