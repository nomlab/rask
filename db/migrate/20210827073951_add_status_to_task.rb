class AddStatusToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :status, :integer
    add_foreign_key :tasks, :states, column: :status
  end
end
