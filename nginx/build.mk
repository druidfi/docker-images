BUILD_TARGETS += nginx-bake-all
NGINX_BAKE_FLAGS := --pull --push

PHONY += nginx-bake-all
nginx-bake-all: ## Bake all Nginx images
	@docker buildx bake -f nginx/docker-bake.hcl $(NGINX_BAKE_FLAGS)

PHONY += nginx-bake-print
nginx-bake-print: NGINX_BAKE_FLAGS := --print
nginx-bake-print: nginx-bake-all ## Print bake plan for Nginx images

PHONY += nginx-bake-local
nginx-bake-local: NGINX_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
nginx-bake-local: nginx-bake-all ## Bake all Nginx images locally

PHONY += nginx-bake-test
nginx-bake-test: MISC_BAKE_FLAGS := --pull --progress plain --no-cache
nginx-bake-test: nginx-bake-all ## CI test for Nginx images
