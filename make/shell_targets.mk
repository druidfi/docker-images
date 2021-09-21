#
# SHELL TARGETS
#

HOST := test.druid.fi

PHONY += shell-php
shell-php: IMG := php
shell-php: TAG := 7.4
shell-php: ## Login to PHP-FPM container
	docker run --rm -it --hostname $(HOST) druidfi/$(IMG):$(TAG) bash

PHONY += shell-php-fpm
shell-php-fpm: IMG := php
shell-php-fpm: TAG := 7.4-fpm
shell-php-fpm: ## Login to PHP-FPM container
	docker run --rm -it --hostname $(HOST) druidfi/$(IMG):$(TAG) bash

PHONY += shell-drupal
shell-drupal: IMG := drupal
shell-drupal: TAG := 7.4
shell-drupal: ## Login to Drupal container
	docker run --rm -it --hostname $(HOST) druidfi/$(IMG):$(TAG) bash

PHONY += shell-qa-toolset
shell-qa-toolset: ## Login to QA toolset container
	docker run --rm -it --hostname drupal-qa druidfi/drupal-qa:8 bash
