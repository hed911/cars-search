class SearchResponseParser < BaseParser
  def format(results)
    results["hits"]["hits"].map { |hit| map(hit) }
  end

  private

  def map(hit)
    source = hit["_source"]
    {
      id: source["car_id"],
      brand: {
        id: source["brand_id"],
        name: source["brand_name"]
      },
      price: source["car_price"],
      rank_score: source["rank_score"],
      model: source["model"],
      label: source["match_type"]
    }
  end
end
