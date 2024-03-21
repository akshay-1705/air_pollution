# frozen_string_literal: true

redis_config = Rails.application.credentials.config[:redis]

Sidekiq.configure_server do |config|
  # Notify errors here
  config.redis = { url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/1" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/1" }
end

# crons = {
#   'air_pollution_cron_worker' => {
#     name: 'AirPollutionCron',
#     cron: '*/30 * * * * *', # Run every 30 seconds
#     class: 'AirPollutionCronWorker',
#     queue: 'default'
#   }
# }

# Sidekiq::Cron::Job.load_from_hash crons
