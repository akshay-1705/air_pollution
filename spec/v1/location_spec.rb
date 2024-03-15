# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Location API', type: :request do
  describe 'POST /api/v1/location' do
    context 'with valid parameters' do
      let(:valid_params) { { zip: '12345', country_code: 'US' } }

      it 'creates a new location' do
        expect do
          post '/api/v1/location', params: valid_params
        end.to change(Location, :count).by(1)
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['success']).to eq(true)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { zip: '', country_code: '' } }

      it 'returns an error message' do
        post '/api/v1/location', params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['success']).to eq(false)
        expect(JSON.parse(response.body)['message']).to eq('Zip/country code cannot be empty')
      end
    end

    context 'when OpenWeatherMapService returns an error' do
      let(:error_response) { double('response', success?: false, code: 500, body: 'Internal Server Error') }
      let(:open_weather_map_service) { instance_double(OpenWeatherMapService) }

      before do
        allow(OpenWeatherMapService).to receive(:new).and_return(open_weather_map_service)
        allow(open_weather_map_service).to receive(:get_coordinates!).and_return(error_response)
      end

      it 'returns an error message' do
        post '/api/v1/location', params: { zip: '12345', country_code: 'US' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['success']).to eq(false)
        expect(JSON.parse(response.body)['message']).to eq('Error retrieving coordinates data: 500 - Internal Server Error')
      end
    end
  end
end
