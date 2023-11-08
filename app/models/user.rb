class User < ApplicationRecord
  include Documentable
  include Elasticable

  has_many :user_preferred_brands, dependent: :destroy
  has_many :preferred_brands, through: :user_preferred_brands, source: :brand

  def match_type(car)
    include_brand = preferred_brands.include?(car.brand)
    include_price = preferred_price_range.include?(car.price)

    return :perfect_match if include_brand && include_price
    return :good_match if include_brand && !include_price
  end
end

