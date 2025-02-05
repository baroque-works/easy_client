# frozen_string_literal: true

module EasyClient
  class Error < StandardError; end

  class ApiError < Error
    attr_reader :response, :code, :error_type

    def initialize(response)
      @response = response
      @code = response.code
      @error_type = parse_error_type
      super(build_message)
    end

    def parse_error_type
      return "unknown" unless response&.content_type == "application/json"

      JSON.parse(response.body)["error_type"]
    rescue JSON::ParserError
      "unknown"
    end

    def build_message
      "API Error (#{code}): #{error_details}"
    end

    def error_details
      return response.body unless response.content_type == "application/json"

      JSON.parse(response.body)["message"]
    rescue JSON::ParserError
      response.body
    end
  end

  class AuthenticationError < ApiError; end
  class RateLimitError < ApiError; end
  class ValidationError < ApiError; end
  class ResourceNotFoundError < ApiError; end
  class ServerError < ApiError; end
  class NetworkError < ApiError; end
  class ConfigurationError < Error; end

  class ErrorHandler
    ERROR_CLASSES = {
      "401" => AuthenticationError,
      "429" => RateLimitError,
      "404" => ResourceNotFoundError,
      "422" => ValidationError
    }.freeze

    def self.handle_response(response)
      return response if response.is_a?(Net::HTTPSuccess)

      error_class = ERROR_CLASSES.fetch(response.code) do
        response.code.to_i >= 500 ? ServerError : ApiError
      end

      raise error_class, response
    end
  end
end
