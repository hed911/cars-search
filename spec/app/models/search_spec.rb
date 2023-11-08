require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:search) { Search.new(user_id: 1) }

  context 'validated_page' do
    it 'should return 0 as default value when page is not present' do
      expect(search.validated_page).to be_zero
    end

    it 'should return the value in page minus one' do
      search.page = 10
      expect(search.validated_page).to be 9
    end
  end

  context 'user_id' do
    it 'present should make valid? as true' do
      expect(search.valid?).to be_truthy
    end

    it 'absent should make valid? as false' do
      search.user_id = nil
      expect(search.valid?).to be_falsey
    end
  end

  context 'query' do
    it 'present should make valid? as true' do
      expect(search.valid?).to be_truthy
    end

    it 'absent should make valid? as true' do
      search.query = ''
      expect(search.valid?).to be_truthy
    end
  end

  [:page, :price_min, :price_max].each do |field|
    context field do
      it 'with a string value should make valid? as false' do
        search.instance_variable_set("@#{field}", "x")
        expect(search.valid?).to be_falsey
      end

      it 'with a negative value should make valid? as false' do
        search.instance_variable_set("@#{field}", "-10")
        expect(search.valid?).to be_falsey
      end

      it 'with a very big integer value should make valid? as false' do
        search.instance_variable_set("@#{field}", (INTEGER_MAX + 1).to_s)
        expect(search.valid?).to be_falsey
      end
  
      it 'absent should make valid? as true' do
        expect(search.valid?).to be_truthy
      end
    end
  end

  context 'add_conditions' do
    it 'should add price_min condition to the result when price_min is present' do
      search.price_min = 100_00
      search.add_conditions
      expect(search.generate_results['query']['bool']['must'].count).to eq 1
    end

    it 'should add price_max condition to the result when price_min is present' do
      search.price_max = 100_00
      search.add_conditions
      expect(search.generate_results['query']['bool']['must'].count).to eq 1
    end

    it 'should add query condition to the result when price_min is present' do
      search.query = "Volks"
      search.add_conditions
      expect(search.generate_results['query']['bool']['must'].count).to eq 1
    end

    it 'should return empty conditions when there are no conditions added' do
      expect(search.generate_results['query']['bool']['must'].count).to eq 0
    end
  end

  context 'add_sorting_config' do
    it 'should add configs to the result' do
      search.add_sorting_config
      expect(search.generate_results['sort'].count).to eq 3
    end
  end

  context 'add_pagination_config' do
    it 'should match page value' do
      search.page = 24
      search.add_pagination_config
      expect(search.generate_results['from']).to eq 23
    end

    it 'should set a default value of 0' do
      search.add_pagination_config
      expect(search.generate_results['from']).to eq 0
    end
  end

  context 'generate_results' do
    it 'should return a key value pair hash' do
      search.page = 24
      search.add_pagination_config
      search.generate_results
      expect(search.generate_results.keys.count).not_to eq 0
    end

    it 'should return an empty hash without any conditions or configs setted' do
      expected_result = {"query"=>{"bool"=>{"must"=>[]}}, "sort"=>[]}
      expect(search.generate_results).to eq(expected_result)
    end
  end

  context 'build_request_params' do
    it 'should call sequentially the add_pagination_config, add_conditions, add_sorting_config, generate_results methods' do
      search.stub(:add_pagination_config)
      search.stub(:add_conditions)
      search.stub(:add_sorting_config)
      search.stub(:generate_results)

      search.build_request_params
      expect(search).to have_received(:add_pagination_config)
      expect(search).to have_received(:add_conditions)
      expect(search).to have_received(:add_sorting_config)
      expect(search).to have_received(:generate_results)
    end
  end
end
