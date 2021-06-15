PHONY += push-drupal-test
push-drupal-test: ## Push all Drupal test images to Docker Hub
	docker push druidfi/drupal:7.3-test
	docker push druidfi/drupal:7.4-test
	docker push druidfi/drupal:8.0-test

PHONY += push-qa
push-qa: ## Push all QA images to Docker Hub
	docker push druidfi/qa:php-7.3
	docker push druidfi/qa:php-7.4

PHONY += push-wp
push-wp: ## Push WordPress images to Docker Hub
	docker push druidfi/wordpress:php-7.3
	docker push druidfi/wordpress:php-7.4
	docker push druidfi/wordpress:php-8.0
