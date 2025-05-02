BAKE_FLAGS := --pull --no-cache --push

PHONY += mautic-bake-all
mautic-bake-all: ## Bake all Mautic images
	docker buildx bake -f mautic/docker-bake.hcl $(BAKE_FLAGS)

PHONY += mautic-bake-print
mautic-bake-print: BAKE_FLAGS := --print
mautic-bake-print: mautic-bake-all ## Print bake plan for Mautic images

PHONY += mautic-bake-local
mautic-bake-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
mautic-bake-local: mautic-bake-all ## Bake all Mautic images locally

PHONY += mautic-bake-test
mautic-bake-test: BAKE_FLAGS := --pull --progress plain --no-cache
mautic-bake-test: mautic-bake-all ## CI test for Mautic images
