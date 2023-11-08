class RecommendationService
  attr_accessor :id

  def initialize(id)
    @id = id
  end

  def fetch
    response = make_request(id)
    parse_response(response) 
  rescue HTTParty::Error, StandardError => e
    logger = Rails.logger
    logger.warning "Error fetching recommendations of car #{car.id}: #{e.message}"
  end

  private

  def make_request(id)
    HTTParty
      .get("#{ENV['RECOMMENDATION_SERVICE_URL']}/recomended_cars.json?user_id=#{id}")
  end

  def parse_response(response)
    response.success? ? response.parsed_response : []
  end
end
