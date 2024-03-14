# frozen_string_literal: true

require 'roar'
require 'roar/json'

class Api < Grape::API
  version 'v1', using: :path

  # Roar
  default_format :json
  format :json
  prefix :api
  formatter :json, Grape::Formatter::Roar

  # Helpers
  helpers V1::Helpers::Utils
  helpers do
    def permitted_params
      @permitted_params ||= declared(params, include_mission: false)
    end
  end

  mount V1::Base

  # Error handling
  rescue_from ActiveRecord::RecordNotFound do
    error!({ message: 'Record Not Found' }, 404)
  end

  rescue_from Grape::Exceptions::ValidationErrors do |err|
    error!({ message: "Invalid params, #{err.message}" }, 402)
  end

  rescue_from StandardError do |err|
    Rails.logger.info("err: #{err.message}")
    Rails.logger.info("err: #{err.backtrace.join("\n")}")
    error!({ message: 'Internal server error' }, 500)
  end

  ## keep this at the bottom.
  route :any, '*path' do
    error!({ message: "No such route '#{request.path}'" }, 404)
  end
end
