PHONY :=

PHONY += build-all
build-all: build-base build-php-fpm build-nginx build-drupal ## Build all PHP images

#
# BUILD TARGETS
#

PHONY += build-base
build-base: ALPINE := 3.10
build-base: ## Build base image
	$(call step,Build druidfi/base:alpine$(ALPINE))
	docker build --force-rm base -t druidfi/base:alpine$(ALPINE) \
		--build-arg ALPINE_VERSION=$(ALPINE)

PHONY += build-php-fpm
build-php-fpm: ## Build PHP-FPM images
#	$(call step,Build druidfi/php:7.2-fpm)
#	docker build --force-rm php-fpm -t druidfi/php:7.2-fpm \
#		--build-arg ALPINE_VERSION=3.9 --build-arg PHP_VERSION=7.2 --build-arg COMPOSER_VERSION=1.9.0
	$(call step,Build druidfi/php:7.3-fpm)
	docker build --force-rm php-fpm -t druidfi/php:7.3-fpm --target baseline \
		--build-arg ALPINE_VERSION=3.10 \
		--build-arg PHP_VERSION=7.3 \
		--build-arg COMPOSER_VERSION=1.9.0

PHONY += build-nginx
build-nginx: NGINX := 1.17
build-nginx: ## Build Nginx images
	$(call step,Build druidfi/nginx:$(NGINX))
	docker build --force-rm nginx -t druidfi/nginx:$(NGINX) \
		--build-arg NGINX_VERSION=$(NGINX)
	$(call step,Build druidfi/nginx-drupal:$(NGINX))
	docker build --force-rm nginx-drupal -t druidfi/nginx:$(NGINX)-drupal \
		--build-arg NGINX_VERSION=$(NGINX)

PHONY += build-drupal
build-drupal: PHP := 7.3
build-drupal: ## Build Drupal images
	$(call step,Build druidfi/drupal:$(PHP))
	docker build --force-rm drupal -t druidfi/drupal:$(PHP) \
    		--build-arg PHP_VERSION=$(PHP)
	$(call step,Build druidfi/drupal:$(PHP)-web)
	docker build --force-rm drupal-web -t druidfi/drupal:$(PHP)-web --target baseline \
    		--build-arg PHP_VERSION=$(PHP) \
    		--build-arg NGINX_VERSION=1.17

build-db: ## Build Database images
	$(call step,Build druidfi/db:mysql5.7)
	docker build --force-rm db/mysql5 -t druidfi/db:mysql5.7-drupal \
			--build-arg MYSQL_VERSION=5.7

#
# TEST TARGETS
#

PHONY += test-php-fpm
test-php-fpm: TAG := 7.3-fpm-alpine3.10
test-php-fpm: ## Test PHP-FPM images
	$(call step,PHP -v FROM druidfi/php:$(TAG))
	docker run --rm -it --user=root druidfi/php:$(TAG) php -v
#	docker run --rm -it --user=root druidfi/php:7.4.0RC3-fpm-alpine3.10 php -v

PHONY += test-drupal
test-drupal: PHP := 7.3
test-drupal: ## Test PHP-FPM images
	$(call step,PHP -v FROM druidfi/drupal:$(PHP))
	docker run --rm -it --user=root druidfi/drupal:$(PHP) php -v
	$(call step,Nginx default.conf content FROM druidfi/drupal-web:$(PHP))
	docker run --rm -it --user=root druidfi/drupal-web:$(PHP) cat /etc/nginx/conf.d/default.conf
	$(call step,MySQL/MariaDB version FROM druidfi/drupal-all:$(PHP))
	docker run --rm -it --user=root druidfi/drupal-all:$(PHP) mysql -V

PHONY += test-drupal-running
test-drupal-running:
	docker-compose -f tests/drupal-and-nginx/docker-compose.yml up -d --remove-orphans

PHONY += example-drupal
example-drupal:
	cd examples/drupal-separate-services && docker-compose up -d --remove-orphans

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

push-all:
#	docker push IMAGE:TAG
	docker push druidfi/base:alpine3.10
	docker push druidfi/php:7.3-fpm
	docker push druidfi/nginx:1.17
	docker push druidfi/nginx:1.17-drupal
	docker push druidfi/drupal:7.3
	docker push druidfi/drupal:7.3-web
	docker push druidfi/db:mysql5.7-drupal

define step
	@printf "\n\e[0;33m${1}\e[0m\n\n"
endef

.PHONY: $(PHONY)
