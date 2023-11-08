require 'rails_helper'

RSpec.describe CarsController, type: :controller do
  describe 'GET search' do
    it 'returns a bad response when search_manager config is not valid' do
      allow_any_instance_of(SearchManager).to receive(:valid?).and_return(false)
      get :search
      expect(response).to_not be_successful
    end

    it 'returns a successful response when search_manager config is valid' do
      allow_any_instance_of(SearchManager).to receive(:valid?).and_return(true)
      get :search
      expect(response).to be_successful
    end
  end
end
