BUILD_TARGETS += db-bake-all
DB_BAKE_FLAGS := --pull --push

PHONY += --db-bake
--db-bake:
	@docker buildx bake -f db/docker-bake.hcl $(DB_BAKE_FLAGS)

PHONY += db-bake-all
db-bake-all: buildx-create --db-bake ## Bake all Database images
	@docker buildx bake -f db/docker-bake.hcl $(DB_BAKE_FLAGS)

PHONY += db-bake-print
db-bake-print: DB_BAKE_FLAGS := --print
db-bake-print: --db-bake ## Print bake plan for Database images

PHONY += db-bake-local
db-bake-local: DB_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
db-bake-local: --db-bake ## Bake all Database images locally

PHONY += db-bake-test
db-bake-test: DB_BAKE_FLAGS := --pull --progress plain --no-cache
db-bake-test: --db-bake ## CI test for Database images
