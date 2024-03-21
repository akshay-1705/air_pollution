# frozen_string_literal: true

module V1
  class Base < Grape::API
    # We can make APIs secure by adding a secure token in the headers
    mount V1::Location
  end
end
