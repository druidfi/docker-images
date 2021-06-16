BUILD_TARGETS += bake-all-nginx

PHONY += bake-all-nginx
bake-all-nginx: ## Bake all Nginx images
	@cd nginx && docker buildx bake --pull --push
