#
# BUILD: Misc images
#

PHONY += build-curl
build-curl: ## Build Curl image
	docker build --no-cache --force-rm misc/curl -t druidfi/curl:alpine$(ALPINE_VERSION) \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION)

PHONY += build-dnsmasq
build-dnsmasq: ## Build dnsmasq image
	docker build --no-cache --force-rm misc/dnsmasq -t druidfi/dnsmasq:alpine$(ALPINE_VERSION) \
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
