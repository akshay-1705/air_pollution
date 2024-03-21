# frozen_string_literal: true

FactoryBot.define do
  factory :location do
    name { 'City' }
    zip { '12345' }
    latitude { 40.7128 }
    longitude { -74.006 }
    country_code { 'US' }
  end
end
