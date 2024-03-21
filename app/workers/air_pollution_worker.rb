# frozen_string_literal: true

class AirPollutionWorker
  include Sidekiq::Worker

  def perform(location_id)
    # Use of find is intentional here.
    location = Location.find(location_id)

    service = AirPollutionService.new
    service.import_data!(location)
  end
end
