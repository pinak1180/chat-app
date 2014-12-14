class AddDeviceInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :device_id, :string
    add_column :users, :device_type, :string, :default => 'iphone'
  end
end
