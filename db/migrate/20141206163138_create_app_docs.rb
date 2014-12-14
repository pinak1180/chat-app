class CreateAppDocs < ActiveRecord::Migration
  def change
    create_table :app_docs do |t|
      t.text :tos
      t.text :privacy

      t.timestamps null: false
    end
  end
end
