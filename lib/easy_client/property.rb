# frozen_string_literal: true

module EasyClient
  class Property
    def initialize(attributes = {})
      @attributes = attributes.transform_keys(&:to_s)
    end

    def method_missing(name, *args)
      key = name.to_s
      return @attributes[key] if @attributes.key?(key)

      super
    end

    def respond_to_missing?(name, include_private = false)
      @attributes.key?(name.to_s) || super
    end

    def self.from_json(json)
      new(json)
    end

    def to_h
      @attributes
    end
  end
end
