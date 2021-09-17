PHONY :=
.DEFAULT_GOAL := help
PROJECT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
DBC := docker build
DBX := docker buildx build
BUILD_DATE := $(shell date +%F)

ifeq ($(shell uname -m),arm64)
	CURRENT_ARCH := arm64
else
	CURRENT_ARCH := amd64
endif

include $(PROJECT_DIR)/make/*.mk

PHONY += help
help: ## List all make commands
	$(call step,Available make commands:)
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort

PHONY += buildx-create
buildx-create: .buildx-builder-created ## Create Buildx Builder

.buildx-builder-created:
	docker buildx create --use --platform linux/amd64,linux/arm64
	touch .buildx-builder-created

BAKE_FLAGS := --pull --progress plain --no-cache

PHONY += bake-php
bake-php:
	@ALPINE_VERSION=$(call get_alpine_version) ALPINE_VERSION_PREVIOUS=$(call get_alpine_version,3.12) \
	PHP73_MINOR=$(call get_php_minor,7.3) PHP74_MINOR=$(call get_php_minor,7.4) PHP80_MINOR=$(call get_php_minor,8.0) \
		docker buildx bake $(BAKE_FLAGS)

PHONY += bake-php-print
bake-php-print: BAKE_FLAGS := --print
bake-php-print: bake-php

PHONY += bake-php-local
bake-php-local: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
bake-php-local: bake-php

PHONY += bake-php-test
bake-php-test: BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH) --set *.target=test
bake-php-test: bake-php

define step
	@printf "\n\e[0;33m${1}\e[0m\n\n"
endef

define get_alpine_version
$(shell bin/helper alpineversion $1)
endef

define get_php_minor
$(shell bin/helper phpminor $1)
endef

.PHONY: $(PHONY)
