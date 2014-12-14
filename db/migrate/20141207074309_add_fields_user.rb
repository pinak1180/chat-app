class AddFieldsUser < ActiveRecord::Migration
  def change
  	add_column :users, :is_online, :boolean, :default => false
  end
end
