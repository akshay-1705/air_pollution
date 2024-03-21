# frozen_string_literal: true

class AirPollutionDataPoint < ApplicationRecord
  belongs_to :location, optional: true

  validates :aqi, :location_id, :received_at, :components, presence: true
  validates :aqi, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  def self.seed!(data, location)
    aqi = data['main']['aqi']
    received_at = Time.zone.at(data['dt'].to_i)

    location.air_pollution_data_points.create!(aqi: aqi, received_at: received_at, components: data['components'])
  end
end
