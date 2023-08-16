BAKE_FLAGS := --pull --no-cache --push

PHONY += app-bake-all
app-bake-all: ## Bake all PHP images
	@PHP81_MINOR=$(call get_php_minor,8.1) PHP82_MINOR=$(call get_php_minor,8.2) \
		docker buildx bake -f app/docker-bake.hcl $(BAKE_FLAGS)

PHONY += app-bake-print
app-bake-print: BAKE_FLAGS := --print
app-bake-print: app-bake-all ## Print bake plan for App images

PHONY += app-bake-local
app-bake-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
app-bake-local: app-bake-all run-app-tests ## Bake all App images locally

PHONY += app-bake-beta
app-bake-beta: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
app-bake-beta: ## Bake all App images locally
	docker buildx bake -f php/docker-bake.hcl $(BAKE_FLAGS) php-beta-variants

PHONY += app-bake-test
app-bake-test: BAKE_FLAGS := --pull --progress plain --no-cache
app-bake-test: app-bake-all run-app-tests ## CI test for App images

PHONY += run-app-tests
run-app-tests:
	$(call step,Run tests in druidfi/app:php-8.1)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/app:php-8.1 /app/scripts/tests.sh
	$(call step,Run tests in druidfi/app:php-8.2)
	@docker run --rm -t -v $(CURDIR)/tests/scripts:/app/scripts druidfi/app:php-8.2 /app/scripts/tests.sh
