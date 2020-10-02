PHONY :=
.DEFAULT_GOAL := help
PROJECT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
DBC := DOCKER_BUILDKIT=1 docker build --progress=plain

include $(PROJECT_DIR)/make/*.mk

ALPINE_VERSION := 3.12
BUILD_DATE := $(shell date +%F)
# see https://www.nginx.com/blog/nginx-1-18-1-19-released/
NGINX_STABLE_VERSION := 1.18
PHP_71_MINOR_TAG := 7.1.33
PHP_73_MINOR_TAG := 7.3.23
PHP_74_MINOR_TAG := 7.4.11
SIMPLESAMLPHP_VERSION := 1.18.8

PHONY += help
help: ## List all make commands
	$(call step,Available make commands:)
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort

define step
	@printf "\n\e[0;33m${1}\e[0m\n\n"
endef

.PHONY: $(PHONY)
