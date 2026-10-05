BAKE_FLAGS := --pull --no-cache --push

PHONY += --drupal-test-bake
--drupal-test-bake:
	@docker buildx bake -f drupal-test/docker-bake.hcl $(BAKE_FLAGS)

PHONY += drupal-test-bake-all
drupal-test-bake-all: buildx-create --drupal-test-bake buildx-destroy ## Bake all Drupal test images

PHONY += drupal-test-bake-print
drupal-test-bake-print: BAKE_FLAGS := --print
drupal-test-bake-print: --drupal-test-bake ## Print bake plan for Drupal test images

PHONY += drupal-test-bake-local
drupal-test-bake-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
drupal-test-bake-local: --drupal-test-bake ## Bake Drupal test images locally
