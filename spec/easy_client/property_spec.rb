# frozen_string_literal: true

RSpec.describe EasyClient::Property do
  describe '.from_json' do
    let(:json_data) do
      {
        'agent' => 'Carol Stills',
        'public_id' => 'EB-XXX123',
        'title' => 'Michael Scott apartment',
        'location' => 'Scranton, Pennsylvania',
        'property_type' => 'Apartment',
        'operations' => [
          {
            'type' => 'sale',
            'amount' => 500000
          }
        ]
      }
    end

    subject(:property) { described_class.from_json(json_data) }

    it 'provides access to all attributes' do
      expect(property.public_id).to eq('EB-XXX123')
      expect(property.title).to eq('Michael Scott apartment')
      expect(property.location).to eq('Scranton, Pennsylvania')
    end

    it 'handles nested data structures' do
      expect(property.operations).to be_an(Array)
      expect(property.operations.first['type']).to eq('sale')
    end

    it 'handles missing attributes' do
      expect(property.respond_to?(:nonexistent)).to be false
      expect { property.nonexistent }.to raise_error(NoMethodError)
    end
  end
end

