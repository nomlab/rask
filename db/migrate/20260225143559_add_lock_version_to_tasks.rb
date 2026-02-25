class AddLockVersionToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :lock_version, :integer
  end
end
