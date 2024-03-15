# frozen_string_literal: true

module V1
  module Helpers
    module Utils
      extend Grape::API::Helpers

      def render_error(code: 422, message: '', data: {})
        status code
        { success: false, message: message, data: data }
      end

      def render_success(code: 200, message: '', data: {})
        status code
        { success: true, message: message, data: data }
      end

      def deny_access
        error!({ message: 'Not Authorized' }, 401)
      end

      def rack_code(symbol)
        Rack::Utils::SYMBOL_TO_STATUS_CODE[symbol.to_sym]
      end
    end
  end
end
