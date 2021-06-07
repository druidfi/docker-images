#
# BUILD: Misc images
#

BUILD_TARGETS += build-all-misc

PHONY += build-all-misc
build-all-misc: build-curl build-dnsmasq build-s3-sync build-saml-idp build-ssh-agent build-varnish ## Build all misc images

PHONY += build-curl
build-curl: ## Build Curl image
	$(DBX) --target base -t druidfi/curl:alpine$(ALPINE_VERSION) --push misc/curl \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-dnsmasq
build-dnsmasq: ## Build dnsmasq image
	$(DBX) --target base -t druidfi/dnsmasq:alpine$(ALPINE_VERSION) --push misc/dnsmasq \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-mailhog
build-mailhog: ## Build mailhog image
	$(DBX) --target base -t druidfi/mailhog:alpine$(ALPINE_VERSION) --push misc/mailhog \
		--build-arg MAILHOG_VERSION=$(MAILHOG_VERSION)

PHONY += build-s3-sync
build-s3-sync: ## Build S3 sync image
	$(DBX) --target base -t druidfi/s3-sync:alpine$(ALPINE_VERSION) --push misc/s3-sync \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-saml-idp
build-saml-idp: ## Build build-saml-idp image
	$(DBX) --target base -t druidfi/saml-idp:$(SIMPLESAMLPHP_VERSION) --push misc/saml-idp \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		--build-arg SIMPLESAMLPHP_VERSION=$(SIMPLESAMLPHP_VERSION)

PHONY += build-ssh-agent
build-ssh-agent: ## Build ssh-agent image
	$(DBX) --target base -t druidfi/ssh-agent:alpine$(ALPINE_VERSION) --push misc/ssh-agent \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-varnish
build-varnish: ## Build Varnish image
	$(call step,Build druidfi/varnish:6-drupal)
	$(DBX) --target base -t druidfi/varnish:6-drupal --push misc/varnish \
