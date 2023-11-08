require 'rails_helper'

RSpec.describe UserPreferredBrand, type: :model do
  let(:user) { User.create(email: 'example@mail.com') }
  let(:brand) { Brand.create(name: 'Volkswagen') }
  let(:user_pb) { UserPreferredBrand.new }
  it 'should save successfully with presence of user and brand' do
    user_pb.user = user
    user_pb.brand = brand
    expect(user_pb.valid?).to be_truthy
  end

  it 'should not save with abscense of user and brand' do
    expect(user_pb.valid?).to be_falsey
  end

  it 'should not save with abscense of user' do
    user_pb.brand = brand
    expect(user_pb.valid?).to be_falsey
  end

  it 'should not save with abscense of brand' do
    user_pb.user = user
    expect(user_pb.valid?).to be_falsey
  end
end
