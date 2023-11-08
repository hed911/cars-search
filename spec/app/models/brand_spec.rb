require 'rails_helper'

RSpec.describe Brand, type: :model do
  it 'can save with empty name' do
    brand = Brand.new(name: '')
    expect(brand.errors).to be_truthy
  end

  it 'can save with NULL name' do
    brand = Brand.new
    expect(brand.errors).to be_truthy
  end

  describe 'associations' do
    it { should have_many(:cars) }
  end
end


