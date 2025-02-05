# frozen_string_literal: true

RSpec.describe EasyClient do
  after { described_class.reset! }

  describe ".configure" do
    it "configures the client" do
      described_class.configure do |config|
        config.api_key = "test-key"
        config.logging_enabled = true
      end

      expect(described_class.configuration.api_key).to eq("test-key")
      expect(described_class.configuration.logging_enabled).to be true
    end
  end

  describe ".client" do
    before do
      described_class.configure { |config| config.api_key = "test-key" }
    end

    it "returns configured client instance" do
      expect(described_class.client).to be_a(EasyClient::Client)
    end

    it "returns new client when configuration changes" do
      original_client = described_class.client

      described_class.configure { |config| config.api_key = "new-key" }

      expect(described_class.client).not_to eq(original_client)
    end
  end
end
