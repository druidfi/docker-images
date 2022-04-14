BUILD_TARGETS += misc-bake-all
MISC_BAKE_FLAGS := --pull --push

PHONY += misc-bake-all
misc-bake-all: ## Bake all misc images
	@ALPINE_VERSION=$(call get_alpine_version) docker buildx bake -f misc/docker-bake.hcl $(MISC_BAKE_FLAGS)

#PHONY += bake-misc-%
#bake-misc-%:
#	@cd misc && ALPINE_VERSION=$(call get_alpine_version) docker buildx bake --pull --push $*

PHONY += misc-bake-print
misc-bake-print: MISC_BAKE_FLAGS := --print
misc-bake-print: misc-bake-all ## Print bake plan for Misc images

PHONY += misc-bake-local
misc-bake-local: MISC_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
misc-bake-local: misc-bake-all ## Bake all Misc images locally

PHONY += misc-bake-localsolr
misc-bake-localsolr: MISC_BAKE_FLAGS := solr --pull --progress plain --no-cache --push
misc-bake-localsolr: misc-bake-all ## Bake all Misc images locally
