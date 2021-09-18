/*
  Warnings:

  - Added the required column `created_at` to the `cities_not_found` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "cities_not_found" ADD COLUMN     "created_at" TIMESTAMP(6) NOT NULL;
