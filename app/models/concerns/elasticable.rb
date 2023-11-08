module Elasticable
  extend ActiveSupport::Concern

  def index
    "search-user-#{id}"
  end

  def client
    @client ||= ElasticWrapper.new
  end

  def should_update?
    TimeDifference.between(last_sync_at, Time.now).in_minutes > ENV["UPDATE_THRESHOLD"].to_i
  end

  def fetch_and_update_elastic
    if last_sync_at.nil?
      client.indices.create(index: index)
    else
      return unless should_update?

      client.indices.delete(index: index)
    end
    recommendation_list.each { |r| update(r) }
    update_attribute(:last_sync_at, Time.now)
  end

  def update(document)
    client.create(index, document)
  end
end
