# frozen_string_literal: true

class Location < ApplicationRecord
  validates :name, :zip, :country_code, :latitude, :longitude, presence: true

  def self.create!(data)
    location = new(
      name: data[:name],
      zip: data[:zip],
      latitude: data[:lat],
      longitude: data[:lon],
      country_code: data[:country_code]
    )

    location.save!
  end
end
