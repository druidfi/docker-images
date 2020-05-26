#
# BUILD: Node images
#

PHONY += build-node-%
build-node-%: ## Build Node images
	$(call step,Build druidfi/node:$*)
	docker build --no-cache --force-rm node -t druidfi/node:$* \
		--build-arg NODE_VERSION=$*
