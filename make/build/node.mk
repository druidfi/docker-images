#
# BUILD: Node images
#

BUILD_TARGETS += build-all-node

PHONY += build-all-node
build-all-node: build-node-8 build-node-10 build-node-12 build-node-14 ## Build all Node LTS images (8, 10, 12, 14)

PHONY += build-node-%
build-node-%: ## Build Node images
	$(call step,Build druidfi/node:$*)
	$(DBC) --no-cache --force-rm node -t druidfi/node:$* \
		--build-arg NODE_VERSION=$*
