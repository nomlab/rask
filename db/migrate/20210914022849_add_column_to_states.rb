class AddColumnToStates < ActiveRecord::Migration[6.1]
  def change
    add_column :states, :priority, :int
    add_column :states, :about, :string
    add_column :states, :color, :string
  end
end
