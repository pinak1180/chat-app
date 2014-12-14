class AddConfirmStatusToFriendship < ActiveRecord::Migration
  def change
    add_column :friendships, :confirm_status, :boolean, :default => false
    add_column :friendships, :channel_id, :string
  end
end
