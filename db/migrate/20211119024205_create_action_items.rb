class CreateActionItems < ActiveRecord::Migration[6.1]
  def change
    create_table :action_items do |t|
      t.string :summary
      t.string :uid
      t.string :url

      t.timestamps null: false
    end
    add_index :action_items, :url, unique: true
  end
end
