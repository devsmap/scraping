const csv = require('csv-parser')
const fs = require('fs')
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const moment = require('moment');
const slug = require('slug');

const cities = [];

fs.createReadStream('seeds/cities.csv')
  .on('error', () => {
  })

  .pipe(csv({ separator: ';' }))
  .on('data', (row) => {
    const city = {
      id: row['city_id'], 
      name: row['city_name'], 
      latitude: row['city_latitude'], 
      longitude: row['city_longitude'], 
      state_id: row['state_id']
    }
    cities.push(city)
  })

  .on('end', () => {
    cities.forEach(async (city) => {
      const upsertCountry = await prisma.cities.upsert({
        where: {
          id: parseInt(city.id)
        },
        update: {},
        create: {
          id: parseInt(city.id), 
          name: city.name, 
          latitude: city.latitude, 
          longitude: city.longitude, 
          is_active: true,       
          slug: slug(city.state_id+"-"+city.name),    
          created_at: moment().format(), 
          updated_at: moment().format(),
          states: {
            connect: { id: parseInt(city.state_id) }
          } 
        }
      });
    });
  });



