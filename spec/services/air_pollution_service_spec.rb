# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AirPollutionService do
  let(:service) { described_class.new }
  let(:location) { create(:location, latitude: 40.7128, longitude: -74.006) }

  describe '#import_data!' do
    context 'when successful response' do
      let(:response_body) do
        { 'list' => [{ 'main' => { 'aqi' => 3 }, 'dt' => Time.current.to_i,
                       'components' => { 'co' => 10, 'no2' => 20, 'o3' => 30 } }] }
      end
      let(:response) { instance_double(HTTParty::Response, success?: true, code: 200, body: response_body.to_json) }

      it 'saves the air pollution data' do
        allow_any_instance_of(OpenWeatherMapService).to receive(:get_current_air_pollution!).and_return(response)
        expect do
          service.import_data!(location)
        end.to change(AirPollutionDataPoint, :count).by(1)
      end
    end

    context 'when unsuccessful response' do
      let(:response) { instance_double(HTTParty::Response, success?: false, code: 500, body: 'Error') }

      it 'raises a StandardError' do
        allow_any_instance_of(OpenWeatherMapService).to receive(:get_current_air_pollution!).and_return(response)
        expect do
          service.import_data!(location)
        end.to raise_error(StandardError, /Error retrieving location data/)
      end
    end
  end
end
