# frozen_string_literal: true

class OpenWeatherMapService
  include HTTParty
  base_uri 'http://api.openweathermap.org'

  def initialize
    api_key = Rails.application.credentials.config[:open_weather_map_key]
    @options = { query: { appid: api_key } }
  end

  def get_coordinates!(zip, country_code)
    params = { zip: "#{zip},#{country_code}" }
    @options[:query].merge!(params)
    response = self.class.get('/geo/1.0/zip', @options)

    # Raise exception if error code is not 404.
    if !response.success? && response.code != 404
      raise StandardError, "Error retrieving coordinates data: #{response.code} - #{response.body}"
    end

    response
  end

  def get_current_air_pollution!(lat, lon)
    params = { lat: lat, lon: lon }
    @options[:query].merge!(params)
    response = self.class.get('/data/2.5/air_pollution', @options)

    # Raise exception if error code is not 404.
    if !response.success? && response.code != 404
      raise StandardError, "Error retrieving location data: #{response.code} - #{response.body}"
    end

    response
  end

  def get_history_air_pollution_data!(lat, lon, start_time, end_time)
    # For large intervals this will take too much time, should add some restriction.
    params = { lat: lat, lon: lon, start: start_time, end: end_time }
    @options[:query].merge!(params)

    response = self.class.get('/data/2.5/air_pollution/history', @options)

    # Raise exception if error code is not 404.
    if !response.success? && response.code != 404
      raise StandardError, "Error retrieving location data: #{response.code} - #{response.body}"
    end

    response
  end
end
