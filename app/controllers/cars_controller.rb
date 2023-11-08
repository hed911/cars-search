class CarsController < ApplicationController
  def search
    service = SearchManager.new(search_params, SearchResponseParser.new)
    service.call if service.valid?
    if service.valid?
      render json: service.results.to_json
      return
    end

    render json: service.full_error_messages, status: 400
  end

  private

  def search_params
    params.permit(:user_id, :query, :price_min, :price_max, :page)
  end
end
