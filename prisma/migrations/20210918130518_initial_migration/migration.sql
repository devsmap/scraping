CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- CreateTable
CREATE TABLE "countries" (
    "id" BIGSERIAL NOT NULL,
    "is_active" BOOLEAN DEFAULT false,
    "is_collected" BOOLEAN DEFAULT false,
    "name" VARCHAR NOT NULL,
    "region" VARCHAR NOT NULL,
    "subregion" VARCHAR NOT NULL,
    "google_uule" VARCHAR NOT NULL,
    "google_gl" VARCHAR NOT NULL,
    "google_hl" VARCHAR,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "countries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "states" (
    "id" BIGSERIAL NOT NULL,
    "country_id" BIGINT NOT NULL,
    "is_active" BOOLEAN DEFAULT false,
    "is_collected" BOOLEAN DEFAULT false,
    "name" VARCHAR NOT NULL,
    "google_uule" VARCHAR NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "states_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cities" (
    "id" BIGSERIAL NOT NULL,
    "state_id" BIGINT NOT NULL,
    "name" VARCHAR NOT NULL,
    "is_active" BOOLEAN DEFAULT true,
    "latitude" VARCHAR NOT NULL,
    "longitude" VARCHAR NOT NULL,
    "slug" VARCHAR,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "cities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cities_not_found" (
    "id" BIGSERIAL NOT NULL,
    "state_id" BIGINT NOT NULL,
    "name" VARCHAR NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "cities_not_found_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" BIGSERIAL NOT NULL,
    "name" VARCHAR NOT NULL,
    "parent_id" BIGINT,
    "is_active" BOOLEAN DEFAULT false,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "companies" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "is_customer" BOOLEAN DEFAULT false,
    "name" VARCHAR,
    "slug" VARCHAR,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,
    "deleted_at" TIMESTAMP(6),

    CONSTRAINT "companies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "jobs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "category_id" BIGINT NOT NULL,
    "company_id" UUID NOT NULL,
    "city_id" BIGINT NOT NULL,
    "is_active" BOOLEAN DEFAULT false,
    "title" VARCHAR,
    "description" TEXT,
    "via" VARCHAR,
    "link" VARCHAR,
    "published_at" TIMESTAMP(6),
    "time_zone" VARCHAR,
    "gogole_job_id" VARCHAR,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,
    "deleted_at" TIMESTAMP(6),
    "deleted_reason" VARCHAR,

    CONSTRAINT "jobs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "index_countries_on_name" ON "countries"("name");

-- CreateIndex
CREATE INDEX "index_states_on_country_id" ON "states"("country_id");

-- CreateIndex
CREATE INDEX "index_states_on_name" ON "states"("name");

-- CreateIndex
CREATE UNIQUE INDEX "index_cities_on_slug" ON "cities"("slug");

-- CreateIndex
CREATE INDEX "index_cities_on_name" ON "cities"("name");

-- CreateIndex
CREATE INDEX "index_cities_on_state_id" ON "cities"("state_id");

-- CreateIndex
CREATE UNIQUE INDEX "index_categories_on_name" ON "categories"("name");

-- CreateIndex
CREATE INDEX "index_categories_on_parent_id" ON "categories"("parent_id");

-- CreateIndex
CREATE UNIQUE INDEX "index_companies_on_slug" ON "companies"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "index_jobs_on_gogole_job_id" ON "jobs"("gogole_job_id");

-- CreateIndex
CREATE INDEX "index_jobs_on_category_id" ON "jobs"("category_id");

-- CreateIndex
CREATE INDEX "index_jobs_on_city_id" ON "jobs"("city_id");

-- CreateIndex
CREATE INDEX "index_jobs_on_company_id" ON "jobs"("company_id");

-- AddForeignKey
ALTER TABLE "states" ADD CONSTRAINT "fk_rails_40bd891262" FOREIGN KEY ("country_id") REFERENCES "countries"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "cities" ADD CONSTRAINT "fk_rails_59b5e22e07" FOREIGN KEY ("state_id") REFERENCES "states"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "fk_rails_82f48f7407" FOREIGN KEY ("parent_id") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "fk_rails_1cf0b3b406" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "fk_rails_54d543406a" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "fk_rails_b34da78090" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
