# frozen_string_literal: true

class Location < ApplicationRecord
  validates :name, :zip, :country_code, :latitude, :longitude, presence: true
  has_many :air_pollution_data_points

  def self.seed!(data)
    find_or_create_by!(
      name: data['name'],
      zip: data['zip'],
      latitude: data['lat'],
      longitude: data['lon'],
      country_code: data['country']
    )
  end

  def self.average_aqi_per_location
    ::Location.joins(:air_pollution_data_points)
              .group('locations.zip')
              .average(:aqi)
              .transform_values { |value| value.to_f.round(2) }
  end

  def self.average_aqi_per_state
    ::Location.joins(:air_pollution_data_points)
              .group('locations.name')
              .average(:aqi)
              .transform_values { |value| value.to_f.round(2) }
  end

  def self.average_aqi_per_month_per_location
    Location.joins(:air_pollution_data_points)
            .group('locations.zip', "EXTRACT(MONTH FROM air_pollution_data_points.received_at) || '-' || EXTRACT(YEAR FROM air_pollution_data_points.received_at)")
            .average('air_pollution_data_points.aqi')
            .transform_values { |value| value.to_f.round(2) }
  end
end
