const csv = require('csv-parser')
const fs = require('fs')
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const moment = require('moment');

const countries = [];

fs.createReadStream('seeds/csv/countries.csv')
  .on('error', () => {
  })

  .pipe(csv({ separator: ';' }))
  .on('data', (row) => {
    const country = {
      id: row['country_id'], 
      name: row['country_name'], 
      region: row['country_region'], 
      subregion: row['country_subregion'], 
      google_gl: row['country_google_gl'], 
      google_hl: row['country_google_hl'],   
    }
    countries.push(country)
  })

  .on('end', () => {
    countries.forEach(async (country) => {
      const upsertCountry = await prisma.countries.upsert({
        where: {
          id: parseInt(country.id)
        },
        update: {},
        create: {
          id: parseInt(country.id), 
          name: country.name, 
          region: country.region, 
          subregion: country.subregion, 
          google_uule: '', 
          google_gl: country.google_gl, 
          google_hl: country.google_hl, 
          is_active: true, 
          is_collected: true,         
          created_at: moment().format(), 
          updated_at: moment().format()   
        },
      });
    });
  });



