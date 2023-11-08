module Documentable
  extend ActiveSupport::Concern

  def service
    @service ||= RecommendationService.new(id)
  end

  def format(recommendation)
    car = Car.find recommendation["car_id"]
    {
      car_id: car.id,
      brand_id: car.brand&.id,
      brand_name: car.brand&.name,
      car_price: car.price,
      rank_score: recommendation["rank_score"],
      model: car.model_name,
      match_type: match_type(car)
    }
  end

  def recommendation_list
    recommendations = service.fetch
    return [] if recommendations.empty? # double check this

    recommendations.map { |r| format(r) }
  end
end
