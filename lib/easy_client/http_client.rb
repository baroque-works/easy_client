# frozen_string_literal: true

module EasyClient
  class HttpClient
    NETWORK_ERRORS = [
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::EHOSTUNREACH,
      Net::OpenTimeout,
      OpenSSL::SSL::SSLError,
      SocketError
    ].freeze

    def initialize(config)
      @config = config
    end

    def get(endpoint, params = {})
      make_request(endpoint, :get, params)
    end

    private

    def make_request(endpoint, method, params)
      uri = build_uri(endpoint, method, params)
      request = build_request(uri, method)

      Logger.log(:debug, "Making #{method.upcase} request to #{uri}")
      response = perform_request(uri, request)
      process_response(response)
    rescue *NETWORK_ERRORS => e
      Logger.log(:error, "Network error: #{e.message}")
      raise NetworkError, "Network error ocurred: #{e.message}"
    end

    def build_uri(endpoint, method, params)
      uri = URI("#{@config.base_url}#{endpoint}")
      uri.query = URI.encode_www_form(params) if method == :get && params.any?
      uri
    end

    def build_request(uri, method)
      request = Object.const_get("Net::HTTP::#{method.to_s.capitalize}").new(uri)
      request["Accept"] = "application/json"
      request["X-Authorization"] = @config.api_key
      request["User-Agent"] = @config.user_agent
      request
    end

    def perform_request(uri, request)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = @config.open_timeout
      http.read_timeout = @config.read_timeout
      http.request(request)
    end

    def process_response(response)
      ErrorHandler.handle_response(response)
      JSON.parse(response.body)
    rescue JSON::ParserError => e
      Logger.log(:error, "Invalid JSON response", error: e.message)
      raise Error, "Invalid JSON response received"
    end
  end
end
