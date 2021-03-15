#
# BUILD: Misc images
#

BUILD_TARGETS += build-all-misc

PHONY += build-all-misc
build-all-misc: build-curl build-dnsmasq build-saml-idp build-ssh-agent build-varnish ## Build all misc images

PHONY += build-curl
build-curl: ## Build Curl image
	docker build --no-cache --force-rm misc/curl -t druidfi/curl:alpine$(ALPINE_VERSION) \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-dnsmasq
build-dnsmasq: ## Build dnsmasq image
	docker build --no-cache --force-rm misc/dnsmasq -t druidfi/dnsmasq:alpine$(ALPINE_VERSION) \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-mailhog
build-mailhog: ## Build mailhog image
	docker build --no-cache --force-rm misc/mailhog -t druidfi/mailhog:$(MAILHOG_VERSION) \
		--build-arg MAILHOG_VERSION=$(MAILHOG_VERSION)

PHONY += build-s3-sync
build-s3-sync: ## Build S3 sync image
	docker build --no-cache --force-rm misc/s3-sync -t druidfi/s3-sync:alpine$(ALPINE_VERSION) \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-saml-idp
build-saml-idp: ## Build build-saml-idp image
	docker build --no-cache --force-rm misc/saml-idp -t druidfi/saml-idp:$(SIMPLESAMLPHP_VERSION) \
		--build-arg SIMPLESAMLPHP_VERSION=$(SIMPLESAMLPHP_VERSION)

PHONY += build-ssh-agent
build-ssh-agent: ## Build ssh-agent image
	docker build --no-cache --force-rm misc/ssh-agent -t druidfi/ssh-agent:alpine$(ALPINE_VERSION) \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-varnish
build-varnish: ## Build Varnish image
	$(call step,Build druidfi/varnish:6-drupal)
	docker build --no-cache --force-rm misc/varnish -t druidfi/varnish:6-drupal
