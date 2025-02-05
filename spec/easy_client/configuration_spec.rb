# frozen_string_literal: true

RSpec.describe EasyClient::Configuration do
  describe "#initialize" do
    it "sets default values" do
      config = described_class.new

      expect(config.base_url).to eq("https://api.stagingeb.com/v1")
      expect(config.api_key).to be_nil
    end
  end

  describe "#validate!" do
    let(:config) { described_class.new }

    context "when api_key is missing" do
      it "raises ConfigurationError" do
        expect { config.validate! }
          .to raise_error(EasyClient::ConfigurationError, "API key is required")
      end
    end

    context "when api_key is present" do
      it "validates successfully" do
        config.api_key = "valid-key"
        expect { config.validate! }.not_to raise_error
      end
    end
  end
end
