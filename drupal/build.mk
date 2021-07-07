PHONY += bake-all-drupal
bake-all-drupal: bake-all-drupal-base bake-all-drupal-web bake-all-drupal-test ## Bake all Drupal images (7.3, 7.4, 8.0)

PHONY += bake-all-drupal-%
bake-all-drupal-%:
	@cd drupal && PHP73_MINOR=$(call get_php_minor,7.3) PHP74_MINOR=$(call get_php_minor,7.4) PHP80_MINOR=$(call get_php_minor,8.0) \
		docker buildx bake --pull --push $*-variants

PHONY += bake-to-local
bake-to-local: TARGET := web-8.0
bake-to-local: ## Bake and load one image to local
	$(call step,Run tests)
	@cd drupal && docker buildx bake \
		--set *.platform=linux/$(CURRENT_ARCH) --set *.target=test --pull --progress plain $(TARGET)
	$(call step,Make actual build)
	@cd drupal && docker buildx bake \
		--set *.platform=linux/$(CURRENT_ARCH) --load --pull --progress plain $(TARGET)
