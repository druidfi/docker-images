BUILD_TARGETS += db-bake-all
DB_BAKE_FLAGS := --pull --push

PHONY += db-bake-all
db-bake-all: ## Bake all Database images
	@docker buildx bake -f db/docker-bake.hcl $(DB_BAKE_FLAGS)

PHONY += db-bake-print
db-bake-print: DB_BAKE_FLAGS := --print
db-bake-print: db-bake-all ## Print bake plan for Database images

PHONY += db-bake-local
db-bake-local: DB_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
db-bake-local: db-bake-all ## Bake all Database images locally
