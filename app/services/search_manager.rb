class SearchManager
  attr_accessor :search, :results, :parser

  def initialize(params, parser, client = ElasticWrapper.new)
    @search = Search.new(params)
    @results = []
    @parser = parser
    @client = client
  end

  def valid?
    @search.valid? && @error.nil?
  end

  def full_error_messages
    valid?
    @search.errors.full_messages + (error.nil? ? [] : [error])
  end

  def call
    request = @search.build_request_params
    @results = client.search(index: "search-user-#{@search.user_id}", body: request)
    @results = parser.format(@results)
  rescue StandardError => e
    @error = "Error in elastic response: #{e.message}"
  end

  private

  attr_accessor :error, :client
end
