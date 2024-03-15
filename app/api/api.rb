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

  rescue_from StandardError do |_err|
    # Notify developers using bugsnag
    error!({ message: 'Internal server error' }, 500)
  end

  mount V1::Base

  ## keep this at the bottom.
  route :any, '*path' do
    error!({ message: "No such route '#{request.path}'" }, 404)
  end
end
