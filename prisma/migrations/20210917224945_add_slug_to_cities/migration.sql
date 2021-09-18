/*
  Warnings:

  - A unique constraint covering the columns `[slug]` on the table `cities` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "cities" ADD COLUMN     "slug" VARCHAR;

-- CreateIndex
CREATE UNIQUE INDEX "index_cities_on_slug" ON "cities"("slug");
