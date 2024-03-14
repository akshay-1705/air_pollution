# frozen_string_literal: true

module V1
  class Location < Grape::API
    namespace :location do
      # We can add support for multiple locations using multithreading.
      # In that case, API must be idempotent and wrapped inside a single transaction.
      desc 'Create location'
      params do
        requires :zip, type: String, desc: 'zip'
        requires :country_code, type: String, desc: 'Country code'
      end
      post '/' do
        if params[:zip].blank? || params[:country_code].blank?
          render_error(message: 'Zip/country code cannot be empty')
        else
          begin
            # Env independent creds for now
            api_key = Rails.application.credentials.config[:open_weather_map_key]
            open_weather_map_service = OpenWeatherMapService.new(api_key)
            response = open_weather_map_service.get_coordinates!(params[:zip], params[:country_code])
            ::Location.create!(response)

            render_success
          rescue StandardError => e
            Rails.logger.info("err: #{e.message}")
            Rails.logger.info("err: #{e.backtrace.join("\n")}")
            # Notify using bugsnag also
            render_error(message: 'An error occurred while saving location')
          end
        end
      end
    end
  end
end
