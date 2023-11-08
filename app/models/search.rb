class Search
  include ActiveModel::Model

  attr_accessor :user_id, :query, :price_min, :price_max, :page

  validates :user_id, presence: true

  validates :page, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: INTEGER_MAX}, unless: -> { page.blank? }
  validates :price_min, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: INTEGER_MAX}, unless: -> { price_min.blank? }
  validates :price_max, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: INTEGER_MAX}, unless: -> { price_max.blank? }

  def validated_page
    page.nil? ? 0 : (page - 1)
  end

  def add_conditions
    if price_min.present?
      query_builder.add_greater_than_equals_condition(attribute: "car_price", value: price_min)
    end
    if price_max.present?
      query_builder.add_less_than_equals_condition(attribute: "car_price", value: price_max)
    end
    if query.present?
      query_builder.add_like_match_condition(string: query)
    end
  end
  
  def add_sorting_config
    query_builder.add_sort_by(attribute: "match_type", order: "desc", missing: "_last", is_string: true)
    query_builder.add_sort_by(attribute: "rank_score", order: "desc", missing: "_last")
    query_builder.add_sort_by(attribute: "car_price", order: "asc", missing: "_last")
  end

  def add_pagination_config
    query_builder.set_pagination(from: validated_page, size: 20)
  end

  def generate_results
    query_builder.request.with_indifferent_access
  end

  def build_request_params
    add_pagination_config
    add_conditions
    add_sorting_config
    generate_results
  end

  private

  def query_builder
    @query_builder ||= QueryBuilder.new
  end
end
