# frozen_string_literal: true

module EasyClient
  class Configuration
    attr_accessor :api_key, :base_url, :read_timeout, :open_timeout,
                  :user_agent, :logging_enabled, :logger

    def initialize
      @base_url = "https://api.stagingeb.com/v1"
      @read_timeout = 10
      @open_timeout = 5
      @user_agent = "EasyClient/#{VERSION}"
      @logging_enabled = false
      @logger = ::Logger.new($stdout)
    end

    def validate!
      raise ConfigurationError, "API key is required" if api_key.nil? || api_key.empty?

      raise ConfigurationError, "Invalid base URL" unless base_url.start_with?("http")

      true
    end
  end
end
