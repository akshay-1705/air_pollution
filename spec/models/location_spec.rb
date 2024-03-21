# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:country_code) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
  end

  describe 'associations' do
    it { should have_many(:air_pollution_data_points) }
  end

  describe '.seed!' do
    let(:valid_data) do
      {
        'name' => 'City',
        'zip' => '12345',
        'lat' => 40.7128,
        'lon' => -74.006,
        'country' => 'US'
      }
    end

    it 'creates a new location with valid data' do
      expect do
        Location.seed!(valid_data)
      end.to change(Location, :count).by(1)
    end

    it 'finds an existing location with the same attributes' do
      create(:location, name: 'City', zip: '12345', latitude: 40.7128, longitude: -74.006, country_code: 'US')

      expect do
        Location.seed!(valid_data)
      end.not_to change(Location, :count)
    end

    it 'raises an error if required attributes are missing' do
      invalid_data = { 'name' => 'City' } # Missing required attributes

      expect do
        Location.seed!(invalid_data)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
