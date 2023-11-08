class AddLastSyncAtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_sync_at, :timestamp
  end
end
