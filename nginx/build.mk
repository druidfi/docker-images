BUILD_TARGETS += bake-all-nginx
NGINX_BAKE_FLAGS := --pull --push

PHONY += bake-all-nginx
bake-all-nginx: ## Bake all Nginx images
	@cd nginx && docker buildx bake $(NGINX_BAKE_FLAGS)

PHONY += bake-nginx-print
bake-nginx-print: NGINX_BAKE_FLAGS := --print
bake-nginx-print: bake-all-nginx

PHONY += bake-nginx-local
bake-nginx-local: NGINX_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
bake-nginx-local: bake-all-nginx
