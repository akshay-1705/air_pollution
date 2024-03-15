# frozen_string_literal: true

class Location < ApplicationRecord
  validates :name, :zip, :country_code, :latitude, :longitude, presence: true

  def self.seed!(data)
    find_or_create_by!(
      name: data['name'],
      zip: data['zip'],
      latitude: data['lat'],
      longitude: data['lon'],
      country_code: data['country']
    )
  end
end
