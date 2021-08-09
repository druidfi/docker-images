BUILD_TARGETS += bake-all-node

PHONY += bake-all-node
bake-all-node: ## Bake all Node LTS images (8, 10, 12, 14, 16)
	@cd node && docker buildx bake --pull --push
