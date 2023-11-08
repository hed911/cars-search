require 'rails_helper'

RSpec.describe Car, type: :model do
  let(:brand) { Brand.create(name: "Dummy brand") }
  let(:car) { Car.new(brand: brand) }
  it 'should save successfully with empty name' do
    brand.name = ''
    expect(brand.valid?).to be_truthy
  end

  it 'should save successfully with NULL name' do
    expect(brand.valid?).to be_truthy
  end

  it 'should save successfully with NULL price' do
    expect(brand.valid?).to be_truthy
  end

  it 'should not save when brand is not present' do
    expect(brand.valid?).to be_truthy
  end

  describe 'associations' do
    it { should belong_to(:brand) }
  end
end
