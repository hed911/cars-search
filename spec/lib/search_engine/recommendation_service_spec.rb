require 'rails_helper'

RSpec.describe RecommendationService, type: :model do
  let(:service) { RecommendationService.new(1) }

  it 'should create HTTP request and return a successful response' do
    response = double('response', parsed_response: [], success?: true)
    allow(HTTParty).to receive(:get).and_return(response)
    expect(service.fetch).not_to be nil
  end

  it 'should create HTTP request and return empty array when an error happened' do
    response = double('response', parsed_response: [], success?: false)
    allow(HTTParty).to receive(:get).and_return(response)
    expect(service.fetch).not_to be nil
  end
end
