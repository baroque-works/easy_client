# frozen_string_literal: true

RSpec.describe EasyClient::HttpClient do
  let(:config) do
    EasyClient::Configuration.new.tap do |c|
      c.api_key = "test-key"
    end
  end
  let(:client) { described_class.new(config) }

  describe "#get" do
    let(:endpoint) { "/properties" }
    let(:params) { { page: 1, limit: 20 } }

    context "when request is successful" do
      before do
        stub_request(:get, "#{config.base_url}#{endpoint}")
          .with(
            query: params,
            headers: {
              "Accept" => "application/json",
              "X-Authorization" => config.api_key
            }
          )
          .to_return(
            status: 200,
            body: { data: "test" }.to_json
          )
      end

      it "returns parsed JSON response" do
        response = client.get(endpoint, params)
        expect(response).to eq({ "data" => "test" })
      end
    end

    context "when request fails" do
      before do
        stub_request(:get, "#{config.base_url}#{endpoint}")
          .to_return(status: 401)
      end

      it "raises authentication error" do
        expect { client.get(endpoint) }
          .to raise_error(EasyClient::AuthenticationError)
      end
    end
  end
end
