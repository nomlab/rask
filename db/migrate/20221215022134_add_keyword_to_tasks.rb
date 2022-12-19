class AddKeywordToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :keyword, :text
  end
end
