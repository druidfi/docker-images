PHONY :=
.DEFAULT_GOAL := help
PROJECT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
DBC := docker build
PLATFORMS := linux/amd64,linux/arm64
DBX := docker buildx build --platform $(PLATFORMS)

ifeq ($(shell uname -m),arm64)
	CURRENT_ARCH := arm64
else
	CURRENT_ARCH := amd64
endif

include $(PROJECT_DIR)/make/*.mk

ALPINE_VERSION := 3.13.5
BUILD_DATE := $(shell date +%F)
# see https://www.nginx.com/blog/nginx-1-18-1-19-released/
NGINX_STABLE_VERSION := 1.20
MAILHOG_VERSION := 1.0.1
SIMPLESAMLPHP_VERSION := 1.18.8

PHONY += help
help: ## List all make commands
	$(call step,Available make commands: $(CURRENT_ARCH))
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort

define step
	@printf "\n\e[0;33m${1}\e[0m\n\n"
endef

.PHONY: $(PHONY)
