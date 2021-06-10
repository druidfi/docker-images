PHONY += bake-all-drupal
bake-all-drupal: ## Bake all Drupal images (7.3, 7.4, 8.0)
	@cd drupal && docker buildx bake --push --progress plain
