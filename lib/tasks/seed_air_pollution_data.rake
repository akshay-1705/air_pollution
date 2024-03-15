# frozen_string_literal: true

namespace :db do
  desc 'Seed air pollution history (last 1 year) data'
  task seed_air_pollution_data: :environment do
    Location.find_each do |a|
      (0..12).to_a.each do |num|
        start_time = (Time.current - num.months).beginning_of_month
        end_time = start_time + 1.hour

        service = OpenWeatherMapService.new
        response = service.get_history_air_pollution_data!(a.latitude, a.longitude,
                                                           start_time.to_i, end_time.to_i)

        unless response.success?
          raise StandardError,
                "Error retrieving location data: #{response.code} - #{response.body}"
        end

        data = JSON.parse(response.body)['list'].first
        next if data.blank?

        ::AirPollutionDataPoint.seed!(data, a)
      end
    end
  end
end
