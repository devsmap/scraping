const dLoop = require('delayed-loop');
const accents = require('remove-accents');
const moment = require('moment');
const slug = require('slug');
const got = require('got');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

(async () => {

  const countries = await prisma.countries.findMany({ where: { is_collected: true } });
  countries.forEach(async (country) => {  
    const states = await prisma.states.findMany({ where: { country_id: parseInt(country.id), is_collected: true }, include: { cities: true } });
    const categories = await prisma.categories.findMany({ where: { parent_id: null, is_active: true } });
    states.forEach(async (state, index) => {
      setTimeout(() => {

        categories.forEach(async (category) => {               
          let url  = build_url(category, state, country);
          
          collect_jobs(category, country, state, category, url);
        });

      }, 2000 * index);

    });
  })

})();

function build_url(category, state, country) {
  var url = "https://serpapi.com/search.json?engine=google_jobs";
      url += "&q="+ state.name + "+" + escape(category.name);
      url += "&gl=" + country.google_gl;      
      url += "&hl=" + country.google_hl;
      url += "&uule=" + state.google_uule;
      url += "&chips=date_posted:week";
      url += "&api_key=bebfd52dac171994660134ca1f3d5a0146e7f7dea592dff3ba25082864bbc98f"

      console.log(category.name + "/ " + state.name + "/ " + url);

  return url;
}

function collect_jobs(category, country, state, category, url) {
  got.get(url, {responseType: 'json'})
  .then(res => {

    if (typeof res.body['jobs_results'] != "undefined") {
      
      res.body['jobs_results'].forEach(async (job) => {

        if (!((/Qualquer lugar|Anywhere/).test(job.location) || (job.location == state.name) || (!job.location || job.location.length === 0 ) )) {
          if ((/hora|hour|minuto|minute|dia|day|día/).test(job.detected_extensions.posted_at)) {

            let posted_at = job.detected_extensions.posted_at;
            let posted_at_int = parseInt(posted_at.match( /\d+/g )[0])

            if ((/dia|day|día/).test(posted_at) && posted_at_int > 15) {
              return;
            }

            // Criar indice para unaccent(name) 
            let city_name_slug = slug(state.id+"-"+job.location.replaceAll(/[^A-Za-z]/g, ' ').split('  ')[0]);
            let cities = await prisma.$queryRaw`SELECT id FROM cities WHERE slug = ${city_name_slug}`;
            
            if ((cities.length) > 0) {

              let posted_at_datetime = '';
              switch (posted_at) {
                case posted_at.match(/hora|hour|minuto|minute/)?.input:

                  switch (posted_at) {
                    case posted_at.match(/hora|hour|/)?.input:
                      posted_at_datetime = moment().subtract(posted_at_int, 'hours').format();
                      break;
                      case posted_at.match(/minuto|minute|/)?.input:
                        posted_at_datetime = moment().subtract(posted_at_int, 'minute').format();
                        break;                      
                  }

                  break;
                case posted_at.match(/dia|day|día/)?.input:
                  posted_at_datetime = moment().subtract(posted_at_int, 'days').format();
                  break;
              }

              try {
                const upsertCompany = await prisma.companies.upsert({
                  where: {
                    slug: slug(job.company_name),
                  },
                  update: {},
                  create: {
                    name: job.company_name, 
                    slug: slug(job.company_name),
                    created_at: moment().format(), 
                    updated_at: moment().format()   
                  },
                });

                const upsertJob = await prisma.jobs.upsert({
                where: {
                  gogole_job_id: job.job_id,
                },
                update: {},
                create: {
                  title: job.title,
                  description: job.description,
                  via: job.via,
                  published_at: posted_at_datetime,
                  time_zone: country.time_zone,
                  is_active: true,
                  created_at: moment().format(), 
                  updated_at: moment().format(),
                  gogole_job_id: job.job_id,
                  categories: {
                    connect: { id: category.id },
                  },
                  cities: {
                    connect: { id: cities[0].id },
                  },
                  companies: {
                    connect: { id: upsertCompany.id },
                  }   
                },
              });                 
              } catch (e) {
                debugger
              }
            } else {
              const createCityNotFound = await prisma.cities_not_found.create({ 
                data: {
                  state_id: state.id,
                  name: job.location, 
                  created_at: moment().format()                    
                } 
              });            
            }
          }
        }
      });
    }
  })
  .catch(err => {
    console.log('Error: ', err.message);
  });
}
