BUILD_TARGETS += build-all-db
BUILDX_PUSH := --push

PHONY += build-all-db
build-all-db: build-mariadb-10.6 build-mysql-5.7 build-mysql-8.0 ## Build all database images

PHONY += build-mariadb-%
build-mariadb-%: ## Build MySQL images
	$(call step,Build druidfi/db:mariadb$*)
	$(DBX) --target base -t druidfi/db:mariadb$*-drupal db/mariadb \
		--build-arg MARIADB_VERSION=$* $(BUILDX_PUSH)

#
# NOTE! No arm images available!!!
#
PHONY += build-mysql-%
build-mysql-%: ## Build MySQL images
	$(call step,Build druidfi/db:mysql$*)
	$(DBC) --no-cache --force-rm db/mysql -t druidfi/db:mysql$*-drupal \
		--build-arg MYSQL_VERSION=$*
