BUILD_TARGETS += nginx-bake-all
NGINX_BAKE_FLAGS := --pull --push

PHONY += --nginx-bake
--nginx-bake:
	@docker buildx bake -f nginx/docker-bake.hcl $(NGINX_BAKE_FLAGS)

PHONY += nginx-bake-all
nginx-bake-all: buildx-create --nginx-bake ## Bake all Nginx images

PHONY += nginx-bake-print
nginx-bake-print: NGINX_BAKE_FLAGS := --print
nginx-bake-print: --nginx-bake ## Print bake plan for Nginx images

PHONY += nginx-bake-local
nginx-bake-local: NGINX_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
nginx-bake-local: --nginx-bake ## Bake all Nginx images locally

PHONY += nginx-bake-test
nginx-bake-test: NGINX_BAKE_FLAGS := --pull --progress plain --no-cache
nginx-bake-test: --nginx-bake ## CI test for Nginx images
