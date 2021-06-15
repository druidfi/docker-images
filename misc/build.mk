BUILD_TARGETS += bake-all-misc

PHONY += bake-all-misc
bake-all-misc: ## Bake all misc images
	@cd misc && ALPINE_VERSION=$(call get_alpine_version) docker buildx bake --pull --push

PHONY += bake-misc-%
bake-misc-%:
	@cd misc && ALPINE_VERSION=$(call get_alpine_version) docker buildx bake --pull --push $*
