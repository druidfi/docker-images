PHONY += bake-all-drupal
bake-all-drupal: ## Bake all Drupal images (7.3, 7.4, 8.0)
	@cd drupal && docker buildx bake --pull --push --progress plain base-variants
	@cd drupal && docker buildx bake --pull --push --progress plain web-variants

PHONY += bake-to-local
bake-to-local: TARGET := web-8.0
bake-to-local: ## Bake and load one image to local
	$(call step,Run tests)
	@cd drupal && docker buildx bake \
		--set *.platform=linux/$(CURRENT_ARCH) --set *.target=test --pull --progress plain $(TARGET)
	$(call step,Make actual build)
	@cd drupal && docker buildx bake \
		--set *.platform=linux/$(CURRENT_ARCH) --load --pull --progress plain $(TARGET)
