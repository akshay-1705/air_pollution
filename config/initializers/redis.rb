# frozen_string_literal: true

redis_config = Rails.application.credentials.config[:redis]
$redis = Redis.new(redis_config)
