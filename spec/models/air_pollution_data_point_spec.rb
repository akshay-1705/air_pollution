# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AirPollutionDataPoint, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:aqi) }
    it { should validate_presence_of(:location_id) }
    it { should validate_presence_of(:received_at) }
    it { should validate_presence_of(:components) }

    it { should validate_numericality_of(:aqi).only_integer }
    it { should validate_numericality_of(:aqi).is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:aqi).is_less_than_or_equal_to(5) }
  end

  describe 'associations' do
    it { should belong_to(:location).optional }
  end

  describe '.seed!' do
    let(:location) { create(:location) }
    let(:valid_data) do
      {
        'main' => { 'aqi' => 3 },
        'dt' => Time.now.to_i,
        'components' => { 'co' => 1.2, 'no' => 2.3 }
      }
    end

    it 'creates a new air pollution data point with valid data' do
      expect do
        AirPollutionDataPoint.seed!(valid_data, location)
      end.to change(AirPollutionDataPoint, :count).by(1)
    end

    it 'sets the attributes correctly' do
      AirPollutionDataPoint.seed!(valid_data, location)
      data_point = AirPollutionDataPoint.last

      expect(data_point.aqi).to eq(3)
      expect(data_point.location).to eq(location)
      expect(data_point.received_at).to be_within(1.second).of(Time.zone.at(valid_data['dt']))
      expect(data_point.components).to eq({ 'co' => 1.2, 'no' => 2.3 })
    end

    it 'raises an error if required attributes are missing' do
      invalid_data = { 'main' => {}, 'dt' => nil, 'components' => {} } # Missing required attributes

      expect do
        AirPollutionDataPoint.seed!(invalid_data, location)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
