const csv = require('csv-parser')
const fs = require('fs')
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const moment = require('moment');

const states = [];
const SPECIAL_KEY_TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'

fs.createReadStream('seeds/csv/states.csv')
  .on('error', () => {
  })

  .pipe(csv({ separator: ';' }))
  .on('data', (row) => {
    const state = {
      id: row['state_id'], 
      country_id: row['country_id'], 
      country_name: row['country_name'], 
      name: row['state_name'] 
    }
    states.push(state)
  })

  .on('end', () => {
    states.forEach(async (state) => {
      let uule_name = state.name + ', ' + state.country_name 
      // let encode_uule = ("w+CAIQICI"+SPECIAL_KEY_TABLE[uule_name.length]+Buffer.from(uule_name).toString('base64')).replaceAll(/[=]/g, '')
            
      console.log(("w+CAIQICI"+SPECIAL_KEY_TABLE[uule_name.length]+Buffer.from(uule_name).toString('base64')).replaceAll(/[=]/g, ''));
      // const upsertCountry = await prisma.states.upsert({
      //   where: {
      //     id: parseInt(state.id)
      //   },
      //   update: {},
      //   create: {
      //     id: parseInt(state.id), 
      //     name: state.name, 
      //     google_uule: encode_uule, 
      //     is_active: true, 
      //     is_collected: true,         
      //     created_at: moment().format(), 
      //     updated_at: moment().format(),
      //     countries: {
      //       connect: { id: parseInt(state.country_id) }
      //     } 
      //   }
      // });
    });
  });



