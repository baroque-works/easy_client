# frozen_string_literal: true

require "net/http"
require "json"
require "logger"

require_relative "easy_client/version"
require_relative "easy_client/configuration"
require_relative "easy_client/logger"
require_relative "easy_client/errors"
require_relative "easy_client/http_client"
require_relative "easy_client/property"
require_relative "easy_client/property_collection"
require_relative "easy_client/client"

module EasyClient
  class << self
    attr_writer :configuration

    def client
      Client.new
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset!
      @configuration = Configuration.new
    end
  end
end
