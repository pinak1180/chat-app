class AddUnreadCountToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :unread_count, :integer, :default => 0
  end
end
