# frozen_string_literal: true

class AirPollutionService
  attr_accessor :location, :data

  def initialize; end

  def import_data!(location)
    self.location = location
    fetch_and_save_data!
  end

  private

  def fetch_and_save_data!
    open_weather_map_service = ::OpenWeatherMapService.new
    response = open_weather_map_service.get_current_air_pollution!(location.latitude, location.longitude)

    unless response.success?
      raise StandardError,
            "Error retrieving location data: #{response.code} - #{response.body}"
    end

    self.data = JSON.parse(response.body)['list'].first
    save_data!
  end

  def save_data!
    raise StandardError, "Received empty data for location id: #{location.id}" if data.blank?

    ::AirPollutionDataPoint.seed!(data, location)
  end
end
