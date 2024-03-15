# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenWeatherMapService do
  let(:service) { described_class.new }

  describe '#get_coordinates!' do
    let(:zip) { '12345' }
    let(:country_code) { 'US' }

    context 'when successful response' do
      let(:response) { instance_double(HTTParty::Response, success?: true, code: 200, body: '{}') }

      it 'returns a successful response' do
        allow(OpenWeatherMapService).to receive(:get).and_return(response)
        expect(service.get_coordinates!(zip, country_code)).to eq(response)
      end
    end

    context 'when unsuccessful response' do
      let(:response) { instance_double(HTTParty::Response, success?: false, code: 500, body: 'Error') }

      it 'raises a StandardError' do
        allow(OpenWeatherMapService).to receive(:get).and_return(response)
        expect do
          service.get_coordinates!(zip, country_code)
        end.to raise_error(StandardError, /Error retrieving coordinates data/)
      end
    end
  end

  describe '#get_current_air_pollution!' do
    let(:lat) { 40.7128 }
    let(:lon) { -74.006 }

    context 'when successful response' do
      let(:response) { instance_double(HTTParty::Response, success?: true, code: 200, body: '{}') }

      it 'returns a successful response' do
        allow(OpenWeatherMapService).to receive(:get).and_return(response)
        expect(service.get_current_air_pollution!(lat, lon)).to eq(response)
      end
    end

    context 'when unsuccessful response' do
      let(:response) { instance_double(HTTParty::Response, success?: false, code: 500, body: 'Error') }

      it 'raises a StandardError' do
        allow(OpenWeatherMapService).to receive(:get).and_return(response)
        expect do
          service.get_current_air_pollution!(lat, lon)
        end.to raise_error(StandardError, /Error retrieving location data/)
      end
    end
  end
end
