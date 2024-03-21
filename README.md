Air Pollution Application Documentation
Summary
The Air Pollution application retrieves Air Quality Index (AQI) data for various locations using the OpenWeatherMap APIs. It consists of the following components:

Location API: This API accepts a zip code and country code to store a location in the database.
Cron Job: A cron job runs every 30 seconds to fetch AQI data for all locations stored in the database. This ensures that the application stays up-to-date with the latest AQI information.
Rake Task: A rake task is responsible for seeding historical AQI data for the past year. This ensures that the application has historical data for analysis and reporting purposes.
By utilizing these components, the Air Pollution application efficiently manages location data and regularly updates AQI information, providing users with accurate and timely air quality information.

Versions
Ruby: 3.0.0
Rails: 7.0.8
PostgreSQL: 15.5
See Gemfile for other gem versions
Setup
Clone the Repository: Use git clone to clone the repository.
Install PostgreSQL Client: Download and install the PostgreSQL client from here.
Create Databases: Create databases air_pollution_development and air_pollution_test using psql.
Setup database.yml: Configure database.yml with appropriate database configurations.
Add Redis Gem: Add the Redis gem to your Gemfile.
Install Redis Client: Install the Redis client on your machine.
Add Redis Credentials: Add Redis credentials (host and port) from the terminal using EDITOR=vim bin/rails credentials:edit.
Configure Redis: Configure config/initializers/redis.rb with Redis credentials.
ruby
Copy code
redis_config = Rails.application.credentials.config[:redis]
$redis = Redis.new(redis_config)
Add Sidekiq and Sidekiq-Cron Gem: Add the Sidekiq and Sidekiq-Cron gems to your Gemfile.
Configure Sidekiq: Configure config/initializers/sidekiq.rb file.
Run Migrations: Run rake db:migrate to execute migrations.
Start Server: Start the server using rails s.
Run Sidekiq: Run Sidekiq using bundle exec sidekiq.
Running Air Pollution Cron
The Air Pollution cron runs every 30 seconds and fetches data for all available locations. This is based on Sidekiq-Cron. To start the cron, ensure that Sidekiq is up and running. Then, run the following commands from the Rails console:

ruby
Copy code
crons = {
  'air_pollution_cron_worker' => {
    name: 'AirPollutionCron',
    cron: '*/30 * * * * *', # Run every 30 seconds
    class: 'AirPollutionCronWorker',
    queue: 'default'
  }
}
Sidekiq::Cron::Job.load_from_hash(crons)
This will trigger the Air Pollution cron and run it every 30 seconds.

Seed Location
API: localhost:3000/api/v1/location
Params: zip and country_code (both required)
This API fetches location details using the OpenWeatherMap API and saves them into the database.
This API is idempotent.
After location data is saved, run rake db:seed_air_pollution_data to seed historical air pollution data.
RSpecs
Run bundle exec rspec to execute the RSpec tests.

This documentation provides an overview of the Air Pollution application, its components, setup instructions, and usage guidelines.
