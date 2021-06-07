PHONY += build-all-nginx
build-all-nginx: build-nginx ## Build all Nginx images

PHONY += build-nginx
build-nginx: ## Build Nginx images
	$(call step,Build druidfi/nginx:$(NGINX_STABLE_VERSION))
	$(DBX) --target base -t druidfi/nginx:$(NGINX_STABLE_VERSION) --push nginx
	$(call step,Build druidfi/nginx:1.20-drupal)
	$(DBX) --target drupal -t druidfi/nginx:$(NGINX_STABLE_VERSION)-drupal --push nginx
