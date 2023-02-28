class AddDocumentTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :document_type, :string
    rename_column :users, :identification, :document_number
  end
end
