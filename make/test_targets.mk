#
# TEST TARGETS
#

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

PHONY += test-app-running
test-app-running: ## Start app test environment (https://app.docker.so)
	$(call step,Run app test container)
	@(cd tests/app/ && docker compose down -v && docker compose up -d --remove-orphans)
	$(call step,See the test site: https://app.docker.so)

PHONY += test-app-down
test-app-down: ## Stop app test environment
	@(cd tests/app/ && docker compose down -v)

PHONY += shell-app
shell-app: ## Shell into the running app test container
	@docker compose -p test-app -f tests/app/compose.yaml exec app bash

PHONY += run-app-tests-compose
run-app-tests-compose: ## Run test script inside the running app test container
	@docker compose -p test-app -f tests/app/compose.yaml exec app /app/scripts/tests.sh

PHONY += example-drupal
example-drupal:
	$(call step,Raise up example Drupal setup with Nginx and PHP containers)
	@(cd examples/drupal-separate-services && docker-compose down -v && docker-compose up -d --remove-orphans)
	$(call step,See the example site: https://example-drupal.docker.so)
