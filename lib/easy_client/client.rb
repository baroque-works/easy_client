# frozen_string_literal: true

module EasyClient
  class Client
    def initialize(config = nil, http_client: nil)
      @config = config || EasyClient.configuration
      @config.api_key = config.api_key if config&.api_key
      @http_client = http_client || HttpClient.new(@config)
    end

    def list_properties(page: 1, limit: 20)
      validate_configuration!
      Logger.log(:debug, "Fetching properties", page: page, limit: limit)
      response = @http_client.get("/properties", page: page, limit: limit)
      PropertyCollection.from_response(response, page: page, limit: limit)
    rescue Error => e
      Logger.log(:error, "Failed to fetch properties", error: e.message)
      raise
    end

    def print_all_property_titles
      page = 1
      printed_titles = Set.new
      loop do
        properties = list_properties(page: page)
        properties.items.each do |property|
          puts property.title unless printed_titles.include?(property.title)
          printed_titles.add(property.title)
        end

        break unless properties.next_page?

        page += 1
      end
    end

    private

    def validate_configuration!
      raise Error, "API key is required" if @config.api_key.nil?
    end
  end
end
