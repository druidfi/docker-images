BUILD_TARGETS += bake-all-db
DB_BAKE_FLAGS := --pull --push

PHONY += bake-all-db
bake-all-db: ## Bake all Database images
	@cd db && docker buildx bake $(DB_BAKE_FLAGS)

PHONY += bake-db-local
bake-db-local: DB_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
bake-db-local: bake-all-db
