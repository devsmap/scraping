const csv = require('csv-parser')
const fs = require('fs')
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const moment = require('moment');

const categories = [];

fs.createReadStream('seeds/csv/categories.csv')
  .on('error', () => {
  })

  .pipe(csv({ separator: ';' }))
  .on('data', (row) => {
    const category = {
      id: row['category_id'], 
      name: row['category_name'], 
      parent_id: row['category_parent_id']
    }
    categories.push(category)
  })

  .on('end', () => {
    categories.forEach(async (category) => {
      console.log(category.id);
      // const upsertCountry = await prisma.categories.upsert({
      //   where: {
      //     id: parseInt(category.id)
      //   },
      //   update: {},
      //   create: {
      //     id: parseInt(category.id),
      //     name: category.name,
      //     is_active: true,     
      //     created_at: moment().format(), 
      //     updated_at: moment().format()
      //   }
      // });
    });
  });



