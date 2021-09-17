-- CreateTable
CREATE TABLE "cities_not_found" (
    "id" BIGSERIAL NOT NULL,
    "state_id" BIGINT NOT NULL,
    "name" VARCHAR NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "cities_not_found_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "index_cities_not_found_on_name" ON "cities_not_found"("name");

-- CreateIndex
CREATE INDEX "index_cities_not_found_on_state_id" ON "cities_not_found"("state_id");
