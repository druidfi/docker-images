BUILD_TARGETS += bake-all-node
NODE_BAKE_FLAGS := --pull --push

PHONY += bake-all-node
bake-all-node: ## Bake all Node LTS images (8, 10, 12, 14, 16)
	@cd node && docker buildx bake $(NODE_BAKE_FLAGS)

PHONY += bake-node-print
bake-node-print: NODE_BAKE_FLAGS := --print
bake-node-print: bake-all-node

PHONY += bake-node-local
bake-node-local: NODE_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
bake-node-local: bake-all-node
