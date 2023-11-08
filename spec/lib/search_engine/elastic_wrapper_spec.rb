require 'rails_helper'

RSpec.describe ElasticWrapper, type: :model do
  let(:client) { ElasticWrapper.new }

  it 'should call get with no errors' do
    allow_any_instance_of(Elasticsearch::Client).to receive(:get)
    client.get(1, 2)
  end

  it 'should call create with no errors' do
    allow_any_instance_of(Elasticsearch::Client).to receive(:create)
    client.create(1, {})
  end

  it 'should call update with no errors' do
    allow_any_instance_of(Elasticsearch::Client).to receive(:update)
    client.update(1, 2, {})
  end

  it 'should call destroy with no errors' do
    allow_any_instance_of(Elasticsearch::Client).to receive(:delete)
    client.destroy(1, 2)
  end

  it 'should call search with no errors' do
    allow_any_instance_of(Elasticsearch::Client).to receive(:search)
    client.search(index: 1, body: {})
  end
end