# frozen_string_literal: true

class AirPollutionCronWorker
  include Sidekiq::Worker

  def perform(*_args)
    # Increase batch size as locations increase
    Location.find_each(batch_size: 10) do |location|
      AirPollutionWorker.perform_async(location.id)
      # We can add some sleep time as locations increase
    end
  end
end
