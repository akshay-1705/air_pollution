# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AirPollutionCronWorker, type: :worker do
  describe '#perform' do
    it 'enqueues AirPollutionWorker for each location' do
      # Create some test locations
      locations = create_list(:location, 3)

      # Expect AirPollutionWorker to be enqueued for each location
      locations.each do |location|
        expect(AirPollutionWorker).to receive(:perform_async).with(location.id)
      end

      # Call the perform method
      subject.perform
    end
  end
end
