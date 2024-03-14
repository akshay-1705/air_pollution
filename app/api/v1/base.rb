# frozen_string_literal: true

module V1
  class Base < Grape::API
    mount V1::Location
  end
end
