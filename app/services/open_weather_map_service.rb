# frozen_string_literal: true

class OpenWeatherMapService
  include HTTParty
  base_uri 'http://api.openweathermap.org'

  def initialize(api_key)
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
end
