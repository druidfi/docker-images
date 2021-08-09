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
