BUILD_TARGETS += bake-all-db

PHONY += bake-all-db
bake-all-db: ## Bake all Database images
	@cd db && docker buildx bake --pull --push
