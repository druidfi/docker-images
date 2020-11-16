#
# BUILD: Database images
#

BUILD_TARGETS += build-all-db

PHONY += build-all-db
build-all-db: build-db-5.7 build-db-8.0 ## Build all database images

PHONY += build-db-%
build-db-%: ## Build Database images
	$(call step,Build druidfi/db:mysql$*)
	docker build --no-cache --force-rm db/mysql -t druidfi/db:mysql$*-drupal \
		--build-arg MYSQL_VERSION=$*
