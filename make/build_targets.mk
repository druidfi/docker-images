BUILD_TARGETS :=

include $(PROJECT_DIR)/frankenphp/build.mk
include $(PROJECT_DIR)/php/build.mk
include $(PROJECT_DIR)/mautic/build.mk
include $(PROJECT_DIR)/nginx/build.mk
include $(PROJECT_DIR)/db/build.mk
include $(PROJECT_DIR)/misc/build.mk
include $(PROJECT_DIR)/drupal-test/build.mk

PHONY += build-all
build-all: $(BUILD_TARGETS) ## Build all images
