# frozen_string_literal: true

RSpec.describe EasyClient::PropertyCollection do
  let(:properties_data) do
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

  describe ".from_response" do
    subject(:collection) do
      described_class.from_response(properties_data, page: 1, limit: 20)
    end

    it "creates collection with property objects" do
      property = collection.items.first
      expect(property).to be_a(EasyClient::Property)
      expect(property.title).to eq("Michael Scott apartment")
      expect(property.agent).to eq("Carol Stills")
    end

    it "sets pagination information" do
      expect(collection.total_count).to eq(1)
      expect(collection.page).to eq(1)
      expect(collection.limit).to eq(20)
    end
  end
end
