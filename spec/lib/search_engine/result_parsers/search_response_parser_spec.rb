require 'rails_helper'

RSpec.describe SearchResponseParser, type: :model do
  let(:parser) { SearchResponseParser.new }
  let(:input) do
    { 
      "hits": {
        "hits": [
          "_source": {
            "car_id": 1,
            "brand_id": 2,
            "brand_name": 'Volkswagen',
            "car_price": 100_000_0,
            "rank_score": 0.8121,
            "model": 'Dummy model',
            "match_type": 'perfect_match'
          }
        ]
      }
    }.with_indifferent_access
  end
  let(:output) do
    [
      {
        id: 1,
        brand: {
          id: 2,
          name: 'Volkswagen'
        },
        price: 100_000_0,
        rank_score: 0.8121,
        model: 'Dummy model',
        label: 'perfect_match'
      }
    ]
  end

  it 'should convert the input hash into desired format' do
    expect(parser.format(input)).to eq output
  end
end
