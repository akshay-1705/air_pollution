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
          # Env independent creds for now
          open_weather_map_service = OpenWeatherMapService.new
          response = open_weather_map_service.get_coordinates!(params[:zip], params[:country_code])

          if response.success?
            data = JSON.parse(response.body)
            ::Location.seed!(data)
            render_success
          else
            render_error(message: "Error retrieving coordinates data: #{response.code} - #{response.body}")
          end
        end
      end
    end
  end
end
