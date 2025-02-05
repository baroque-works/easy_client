# frozen_string_literal: true

module EasyClient
  class PropertyCollection
    include Enumerable

    attr_reader :items, :total_count, :page, :limit

    def initialize(items, total_count:, page:, limit:)
      @items = items
      @total_count = total_count
      @page = page
      @limit = limit
    end

    def each(&block)
      items.each(&block)
    end

    def self.from_response(response, page:, limit:)
      items = response["content"].map { |item| Property.from_json(item) }
      total = response.dig("pagination", "total") || items.count

      new(items, total_count: total, page: page, limit: limit)
    end

    def next_page?
      page * limit < total_count
    end

    def prev_page?
      page > 1
    end

    def total_pages
      (total_count.to_f / limit).ceil
    end

    def inspect
      "#<#{self.class} items=#{items.count} page=#{page}/#{total_pages}>"
    end
  end
end
