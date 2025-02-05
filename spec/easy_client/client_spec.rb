# frozen_string_literal: true

RSpec.describe EasyClient::Client do
  let(:config) do
    EasyClient::Configuration.new.tap { |c| c.api_key = "test-key" }
  end

  let(:client) { described_class.new(config) }

  describe "#list_properties" do
    let(:properties_response) do
      {
        "content" => [
          {
            "agent" => "Carol Stills",
            "public_id" => "EB-XXX123",
            "title" => "Michael Scott apartment",
            "location" => "Scranton, Pennsylvania",
            "property_type" => "Apartment",
            "operations" => [
              {
                "type" => "sale",
                "amount" => 500_000
              }
            ]
          }
        ],
        "pagination" => {
          "total" => 1,
          "page" => 1,
          "limit" => 20
        }
      }
    end

    context "when request is successful" do
      before do
        stub_request(:get, "#{config.base_url}/properties")
          .with(
            query: { page: 1, limit: 20 },
            headers: { "X-Authorization" => "test-key" }
          )
          .to_return(
            status: 200,
            body: properties_response.to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "returns property collection with correct data" do
        result = client.list_properties
        property = result.items.first

        expect(property.agent).to eq("Carol Stills")
        expect(property.public_id).to eq("EB-XXX123")
        expect(property.title).to eq("Michael Scott apartment")
        expect(property.location).to eq("Scranton, Pennsylvania")
        expect(property.property_type).to eq("Apartment")
        expect(property.operations.first["type"]).to eq("sale")
        expect(property.operations.first["amount"]).to eq(500_000)
      end
    end

    context "when request fails" do
      before do
        stub_request(:get, "#{config.base_url}/properties")
          .with(
            headers: { 
              'X-Authorization' => 'test-key',
              'Accept' => 'application/json'
            },
            query: { page: 1, limit: 20 }
          )
          .to_return(
            status: 500, 
            body: { error: "Server error" }.to_json,
            headers: { 
              'Content-Type' => 'application/json' 
            }
          )
      end

      it "raises error" do
        expect { client.list_properties }.to raise_error(EasyClient::Error)
      end
    end
  end

  describe '#print_all_property_titles' do
    let(:page_1_response) do
      {
        'content' => [
          { 'title' => 'Casa en Monterrey' },
          { 'title' => 'Departamento en San Pedro' }
        ],
        'pagination' => {
          'total' => 40,
          'page' => 1,
          'limit' => 20
        }
      }
    end

    let(:page_2_response) do
      {
        'content' => [
          { 'title' => 'Terreno en Santiago' }
        ],
        'pagination' => {
          'total' => 3,
          'page' => 2,
          'limit' => 20
        }
      }
    end

    before do
      stub_request(:get, "#{config.base_url}/properties")
        .with(
          query: { page: 1, limit: 20 },
          headers: { 'X-Authorization' => 'test-key' }
        )
        .to_return(
          status: 200,
          body: page_1_response.to_json
        )

      stub_request(:get, "#{config.base_url}/properties")
        .with(
          query: { page: 2, limit: 20 },
          headers: { 'X-Authorization' => 'test-key' }
        )
        .to_return(
          status: 200,
          body: page_2_response.to_json
        )
    end

  it 'prints all property titles' do
    expected_output = "Casa en Monterrey\nDepartamento en San Pedro\nTerreno en Santiago\n"
    expect { client.print_all_property_titles }.to output(expected_output).to_stdout
  end
  end
end
