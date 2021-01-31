#
# SCAN TARGETS
#

DRUPAL_IMAGES := drupal:7.3-web drupal:7.4-web drupal:8.0-web
ALL_IMAGES := $(DRUPAL_IMAGES)

PHONY += scan-drupal
scan-drupal: ## Scan all Drupal images with Trivy
	$(call step,Scan all Drupal images with Trivy)
	@$(foreach img,$(DRUPAL_IMAGES),trivy druidfi/$(img);)

PHONY += scan-ci
scan-ci: ## Scan all images with Trivy in CI
	$(call step,Scan all images with Trivy in CI)
	$(foreach img,$(ALL_IMAGES),trivy --exit-code 1 --severity CRITICAL druidfi/$(img);)
