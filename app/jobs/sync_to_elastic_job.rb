class SyncToElasticJob < ApplicationJob
  def perform(ids)
    users = User.where(id: ids)
    users.each(&:fetch_and_update_elastic)
  end
end
