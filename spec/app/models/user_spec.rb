require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:user_preferred_brands) }
    it { should have_many(:preferred_brands) }
  end

  it 'can save with empty email' do
    user = User.new(email: '')
    expect(user.errors).to be_truthy
  end

  it 'can save with NULL email' do
    user = User.new
    expect(user.errors).to be_truthy
  end

  context 'match type' do
    it 'should return :perfect_match if the car price is within preferred_price_range and is present in the preferred_brands list' do
      user = User.create(email: 'test@gmail.com', preferred_price_range: 1000..3000)
      brand = Brand.create(name: 'Volkswagen')
      car = Car.create(model: 'dummy model', brand: brand, price: 2000)
      UserPreferredBrand.create(user_id: user.id, brand_id: brand.id)
      expect(user.match_type(car)).to be :perfect_match
    end

    it 'should return :perfect_match if the car price is within preferred_price_range and is present in the preferred_brands list' do
      user = User.create(email: 'test@gmail.com', preferred_price_range: 1000..3000)
      brand = Brand.create(name: 'Volkswagen')
      car = Car.create(model: 'dummy model', brand: brand, price: 5000)
      UserPreferredBrand.create(user_id: user.id, brand_id: brand.id)
      expect(user.match_type(car)).to be :good_match
    end

    it 'should return NULL if the car price is not within preferred_price_range and is not present in the preferred_brands list' do
      user = User.create(email: 'test@gmail.com', preferred_price_range: 1000..3000)
      brand = Brand.create(name: 'Volkswagen')
      car = Car.create(model: 'dummy model', brand: brand, price: 5000)
      expect(user.match_type(car)).to be nil
    end
  end

  context 'elasticable' do
    it 'index should match with the "search-user-" prefix + id' do
      user = User.create(email: 'test@gmail.com')
      expect(user.index).to eq "search-user-#{user.id}"
    end

    context 'should_update?' do
      it 'should be true if the minutes between last_sync_at and current time is greater than the threshold' do
        last_sync_at = Time.now - (ENV["UPDATE_THRESHOLD"].to_i + 1).minutes
        user = User.new(email: 'test@gmail.com', last_sync_at: last_sync_at)
        expect(user.should_update?).to be_truthy
      end
      
      it 'should be false if the minutes between last_sync_at and current time is less than the threshold' do
        last_sync_at = Time.now - (ENV["UPDATE_THRESHOLD"].to_i - 1).minutes
        user = User.new(email: 'test@gmail.com', last_sync_at: last_sync_at)
        expect(user.should_update?).to be_falsey
      end
    end

    context 'update' do
      it 'should call elastic wrapper create method' do
        allow_any_instance_of(ElasticWrapper).to receive(:create)
        user = User.new(email: 'test@gmail.com')
        user.update({})
      end
    end
  end
end
