BAKE_FLAGS := --pull --no-cache --push

PHONY += drupal-test-bake-all
drupal-test-bake-all: ## Bake all PHP images
	docker buildx bake -f drupal-test/docker-bake.hcl $(BAKE_FLAGS)

PHONY += drupal-test-bake-print
drupal-test-bake-print: BAKE_FLAGS := --print
drupal-test-bake-print: drupal-test-bake-all ## Print bake plan for PHP images

PHONY += drupal-test-bake-local
drupal-test-bake-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
drupal-test-bake-local: drupal-test-bake-all ## Bake all PHP images locally
