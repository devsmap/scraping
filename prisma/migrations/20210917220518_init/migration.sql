-- CreateTable
CREATE TABLE "ar_internal_metadata" (
    "key" VARCHAR NOT NULL,
    "value" VARCHAR,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "ar_internal_metadata_pkey" PRIMARY KEY ("key")
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
CREATE TABLE "cities" (
    "id" BIGSERIAL NOT NULL,
    "state_id" BIGINT NOT NULL,
    "name" VARCHAR NOT NULL,
    "is_active" BOOLEAN DEFAULT true,
    "latitude" VARCHAR NOT NULL,
    "longitude" VARCHAR NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "cities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cities_not_found" (
    "id" BIGSERIAL NOT NULL,
    "state_id" BIGINT NOT NULL,
    "name" VARCHAR NOT NULL,

    CONSTRAINT "cities_not_found_pkey" PRIMARY KEY ("id")
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
CREATE TABLE "employees" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "email" VARCHAR NOT NULL DEFAULT E'',
    "encrypted_password" VARCHAR NOT NULL DEFAULT E'',
    "reset_password_token" VARCHAR,
    "reset_password_sent_at" TIMESTAMP(6),
    "remember_created_at" TIMESTAMP(6),
    "sign_in_count" INTEGER NOT NULL DEFAULT 0,
    "current_sign_in_at" TIMESTAMP(6),
    "last_sign_in_at" TIMESTAMP(6),
    "current_sign_in_ip" VARCHAR,
    "last_sign_in_ip" VARCHAR,
    "confirmation_token" VARCHAR,
    "confirmed_at" TIMESTAMP(6),
    "confirmation_sent_at" TIMESTAMP(6),
    "unconfirmed_email" VARCHAR,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "employees_pkey" PRIMARY KEY ("id")
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

-- CreateTable
CREATE TABLE "schema_migrations" (
    "version" VARCHAR NOT NULL,

    CONSTRAINT "schema_migrations_pkey" PRIMARY KEY ("version")
);

-- CreateTable
CREATE TABLE "states" (
    "id" BIGSERIAL NOT NULL,
    "country_id" BIGINT NOT NULL,
    "is_active" BOOLEAN DEFAULT false,
    "is_collected" BOOLEAN DEFAULT false,
    "name" VARCHAR NOT NULL,
    "state_code" VARCHAR NOT NULL,
    "latitude" VARCHAR NOT NULL,
    "longitude" VARCHAR NOT NULL,
    "google_uule" VARCHAR NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "states_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "index_categories_on_name" ON "categories"("name");

-- CreateIndex
CREATE INDEX "index_categories_on_parent_id" ON "categories"("parent_id");

-- CreateIndex
CREATE INDEX "index_cities_on_name" ON "cities"("name");

-- CreateIndex
CREATE INDEX "index_cities_on_state_id" ON "cities"("state_id");

-- CreateIndex
CREATE INDEX "index_cities_not_found_on_name" ON "cities_not_found"("name");

-- CreateIndex
CREATE INDEX "index_cities_not_found_on_state_id" ON "cities_not_found"("state_id");

-- CreateIndex
CREATE UNIQUE INDEX "index_companies_on_slug" ON "companies"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "index_countries_on_name" ON "countries"("name");

-- CreateIndex
CREATE UNIQUE INDEX "index_employees_on_email" ON "employees"("email");

-- CreateIndex
CREATE UNIQUE INDEX "index_employees_on_reset_password_token" ON "employees"("reset_password_token");

-- CreateIndex
CREATE UNIQUE INDEX "index_employees_on_confirmation_token" ON "employees"("confirmation_token");

-- CreateIndex
CREATE UNIQUE INDEX "index_jobs_on_gogole_job_id" ON "jobs"("gogole_job_id");

-- CreateIndex
CREATE INDEX "index_jobs_on_category_id" ON "jobs"("category_id");

-- CreateIndex
CREATE INDEX "index_jobs_on_city_id" ON "jobs"("city_id");

-- CreateIndex
CREATE INDEX "index_jobs_on_company_id" ON "jobs"("company_id");

-- CreateIndex
CREATE INDEX "index_states_on_country_id" ON "states"("country_id");

-- CreateIndex
CREATE INDEX "index_states_on_name" ON "states"("name");

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "fk_rails_82f48f7407" FOREIGN KEY ("parent_id") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "cities" ADD CONSTRAINT "fk_rails_59b5e22e07" FOREIGN KEY ("state_id") REFERENCES "states"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "fk_rails_1cf0b3b406" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "fk_rails_54d543406a" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "fk_rails_b34da78090" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "states" ADD CONSTRAINT "fk_rails_40bd891262" FOREIGN KEY ("country_id") REFERENCES "countries"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
