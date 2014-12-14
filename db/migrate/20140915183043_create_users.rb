class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.text :auth_token
      t.string :provider

      t.timestamps
    end
  end
end
