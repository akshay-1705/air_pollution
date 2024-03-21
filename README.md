# Summary
	The Air Pollution application retrieves Air Quality Index (AQI) data for various locations using the OpenWeatherMap APIs. It has the following components:
	------------
	1. Location API: This API accepts a zip code and country code to store a location in the database.
	2. Cron Job: A cron job runs every 30 seconds to fetch AQI data for all locations stored in the database. This ensures that the application stays up-to-date with the latest AQI information.
	3. Rake Task: There is a rake task responsible for seeding historical AQI data for the past year. This ensures that the application has historical data for analysis and reporting purposes.
	------------
	By utilizing these components, the Air Pollution application efficiently manages location data and regularly updates AQI information, providing users with accurate and timely air quality information.

# Versions
	* Ruby: 3.0.0
	* Rails: 7.0.8
	* Postgres: 15.5
	* See Gemfile for other gem versions


# Setup
	* Clone the repo using git repo clone
	* Download and install postgres client using: https://www.postgresql.org/download/
	* Create database air_pollution_development and air_pollution_test using psql
	* Setup database.yml
	* Add redis gem
	* Add redis client to your machine
	* Add redis credentials (host and port) from terminal using EDITOR=vim bin/rails credentials:edit
	* Configure config/initializers/redis.rb:
	  redis_config = Rails.application.credentials.config[:redis]
	  $redis = Redis.new(redis_config)
	* Add sidekiq and sidekiq-cron gem
	* Configure config/initializers/sidekiq.rb file.
	* Run rake db:migrate
	* Start server using rails s
	* Run sidekiq using: bundle exec sidekiq

# Running air pollution cron
	Air pollution cron runs every 30 seconds and fetches data for all the available locations.
	This is based on sidekiq-cron. To start the cron, ensure that sidekiq is up and running.
	Then run these commands from the rails console:
	*****************
	 crons = {
	   'air_pollution_cron_worker' => {
	     name: 'AirPollutionCron',
	     cron: '*/30 * * * * *', # Run every 30 seconds
	     class: 'AirPollutionCronWorker',
	     queue: 'default'
	   }
	 }
	 Sidekiq::Cron::Job.load_from_hash crons
	*****************
	This will trigger air pollution cron and will run it every 30 seconds

# Seed location
	API: localhost:3000/api/v1/location
	Params: zip and country code (both required)
	This API fetches location details using openweathermap API and saves into the database.
	This API is idempotent.
	After location data is saved. Run `rake db:seed_air_pollution_data` to seed history air pollution data

# Rspecs
	Run `bundle exec rspec` to run the rspecs
