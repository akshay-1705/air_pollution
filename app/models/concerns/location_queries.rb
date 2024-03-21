# frozen_string_literal: true

module LocationQueries
  extend ActiveSupport::Concern

  included do
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
      # Add combined index when scale is large
      Location.joins(:air_pollution_data_points)
              .group('locations.zip', "EXTRACT(MONTH FROM air_pollution_data_points.received_at) || '-' || EXTRACT(YEAR FROM air_pollution_data_points.received_at)")
              .average('air_pollution_data_points.aqi')
              .transform_values { |value| value.to_f.round(2) }
    end

    def self.locations_with_healthy_aqi
      Location.joins(:air_pollution_data_points)
              .group(:id)
              .having('AVG(air_pollution_data_points.aqi) <= ?', 3)
    end

    def self.locations_with_unhealthy_aqi
      Location.joins(:air_pollution_data_points)
              .group(:id)
              .having('AVG(air_pollution_data_points.aqi) > ?', 3)
    end
  end
end
