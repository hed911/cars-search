require 'rails_helper'

RSpec.describe SearchManager, type: :model do
  let(:search_manager) { SearchManager.new({}, SearchResponseParser.new) }
  let(:params) { { user_id: 1 } }
  let(:result) { { "hit": { "hits": [] } } }

  let(:stubbed_search_manager) do
    client = ElasticWrapper.new
    allow(client).to receive(:search).and_return(result)
    SearchManager.new(params, SearchResponseParser.new, client)
  end

  context 'constructor' do
    it 'should set parser in the instance variable @parser' do
      parser = SearchResponseParser.new
      search_manager = SearchManager.new({}, parser)
      expect(search_manager.parser).to eq parser
    end
  end

  context 'valid?' do
    it 'should return false if there are wrong params' do
      expect(search_manager.valid?).to be_falsey
    end

    it 'should return false if there is an error in the service call' do
      search_manager.call
      expect(search_manager.valid?).to be_falsey
    end

    it 'should return true if params are ok and there are no error set' do
      search_manager = SearchManager.new(params, SearchResponseParser.new)
      expect(search_manager.valid?).to be_truthy
    end
  end

  context 'call' do
    it 'should return results when calling the service' do
      stubbed_search_manager.call
      expect(stubbed_search_manager.results.count).not_to eq 0
    end

    it 'should set error when service is not working' do
      search_manager.call
      expect(search_manager.results.count).to eq 0
    end
  end

  context 'full_error_messages' do
    it 'should return errors if there are wrong params' do
      expect(search_manager.full_error_messages).not_to be_empty
    end

    it 'should return errors if there is an error in the service call' do
      search_manager.call
      expect(search_manager.full_error_messages).not_to be_empty
    end

    it 'should return true if params are ok and there are no error set' do
      expect(stubbed_search_manager.full_error_messages).to be_empty
    end
  end
end
