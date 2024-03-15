# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AirPollutionWorker, type: :worker do
  describe '#perform' do
    let(:location) { create(:location) }

    it 'calls import_data! method of AirPollutionService with location' do
      service_instance = instance_double(AirPollutionService)
      allow(AirPollutionService).to receive(:new).and_return(service_instance)
      expect(service_instance).to receive(:import_data!).with(location)

      subject.perform(location.id)
    end

    it 'raises error if location not found' do
      expect do
        subject.perform(999) # Non-existent location id
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
