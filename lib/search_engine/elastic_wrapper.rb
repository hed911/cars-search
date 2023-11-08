class ElasticWrapper
  def initialize(cloud_id: ENV['ELASTIC_CLOUD_ID'], api_key: ENV['ELASTIC_API_KEY'])
    @cloud_id = cloud_id
    @api_key = api_key
  end

  def client
    @client ||= Elasticsearch::Client.new(
      cloud_id: cloud_id,
      api_key: api_key
    )  
  end

  def get(index, id)
    client.get(index: index, id: id)
  end

  def create(index, document)
    client.index(index: index, body: document)
  end

  def update(index, id, document)
    client.update(index: index, id: id, body: document)
  end

  def destroy(index, id)
    client.delete(index: index, id: id)
  end

  def search(index:, body:)
    client.search(index: index, body: body)
  end

  def method_missing(method, *args, &block)
    client.send(method, *args) { block }
  end

  private

  attr_reader :index, :cloud_id, :api_key
end
