class AddLockVersionToDocuments < ActiveRecord::Migration[7.2]
  def change
    add_column :documents, :lock_version, :integer
  end
end
