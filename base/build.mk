PHONY += build-all-base
build-all-base: build-base-3.12.7 build-base-3.13.5 ## Build all Base images

PHONY += build-base-%
build-base-%: ## Build base images
	$(call step,Build druidfi/base:alpine$*)
	$(DBX) --target base -t druidfi/base:alpine$* --push base \
		--build-arg ALPINE_VERSION=$*
