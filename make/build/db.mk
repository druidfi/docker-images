#
# BUILD: Database images
#

PHONY += build-db-%
build-db-%: ## Build Database images
	$(call step,Build druidfi/db:mysql$*)
	docker build --no-cache --force-rm db/mysql -t druidfi/db:mysql$*-drupal \
		--build-arg MYSQL_VERSION=$*
