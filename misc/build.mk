BUILD_TARGETS += bake-all-misc
MISC_BAKE_FLAGS := --pull --push

PHONY += bake-all-misc
bake-all-misc: ## Bake all misc images
	@cd misc && ALPINE_VERSION=$(call get_alpine_version) docker buildx bake $(MISC_BAKE_FLAGS)

#PHONY += bake-misc-%
#bake-misc-%:
#	@cd misc && ALPINE_VERSION=$(call get_alpine_version) docker buildx bake --pull --push $*

PHONY += bake-misc-print
bake-misc-print: MISC_BAKE_FLAGS := --print
bake-misc-print: bake-all-misc

PHONY += bake-misc-local
bake-misc-local: MISC_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
bake-misc-local: bake-all-misc
