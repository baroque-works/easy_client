# frozen_string_literal: true

module EasyClient
  class Logger
    LEVELS = %i[debug info warn error].freeze

    def self.log(level, message, payload = {})
      return unless EasyClient.configuration.logging_enabled
      return unless LEVELS.include?(level)

      log_entry = {
        timestamp: Time.now.iso8601,
        level: level,
        message: message
      }.merge(payload)

      EasyClient.configuration.logger.send(level, log_entry.to_json)
    end
  end
end
