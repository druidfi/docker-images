BUILD_TARGETS := bake-all-base

PHONY += bake-all-base
bake-all-base: ## Bake all Base images
	@cd base && ALPINE_VERSION=$(call get_alpine_version) ALPINE_VERSION_PREVIOUS=$(call get_alpine_version,3.12) \
		docker buildx bake --pull --push
