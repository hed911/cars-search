class QueryBuilder
  attr_accessor :request

  def initialize
    @request = { sort: [], query: { bool: { must: [] } } }
  end

  def set_pagination(from:, size:)
    request.merge!({ from: from, size: size })
  end

  def add_like_match_condition(string:)
    request[:query][:bool][:must] << {
      query_string: {
        query: "*#{string}*"
      }
    }
  end

  def add_greater_than_equals_condition(attribute:, value:)
    add_range_condition(attribute: attribute, value: value, key: :gte)
  end

  def add_less_than_equals_condition(attribute:, value:)
    add_range_condition(attribute: attribute, value: value, key: :lte)
  end

  def add_range_condition(attribute:, value:, key:)
    record = request[:query][:bool][:must].find { |c| c[:range].keys[0].to_s == attribute }
    not_found = record.nil?
    record = { range: { "#{attribute}": {} } } if not_found
    record[:range][attribute.to_sym][key] = value
    request[:query][:bool][:must] << record if not_found
  end

  def add_sort_by(attribute:, order:, missing:, is_string: false)
    attribute = "#{attribute}.keyword" if is_string
    new_record = {
      "#{attribute}": {
        order: order
      }
    }
    new_record[attribute.to_sym][:missing] = missing if missing
    new_record[attribute.to_sym][:unmapped_type] = 'long' unless is_string
    request[:sort] << new_record
  end
end
