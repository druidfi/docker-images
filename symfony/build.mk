BAKE_FLAGS := --pull --no-cache --push

PHONY += symfony-bake-all
symfony-bake-all: ## Bake all Symfony images
	PHP81_MINOR=$(call get_php_minor,8.1) docker buildx bake -f symfony/docker-bake.hcl $(BAKE_FLAGS)

PHONY += symfony-bake-print
symfony-bake-print: BAKE_FLAGS := --print
symfony-bake-print: symfony-bake-all

PHONY += symfony-bake-local
symfony-bake-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
symfony-bake-local: symfony-bake-all ## Bake all Symfony images locally
