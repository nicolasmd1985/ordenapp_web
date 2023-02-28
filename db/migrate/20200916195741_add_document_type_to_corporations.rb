class AddDocumentTypeToCorporations < ActiveRecord::Migration[5.2]
  def change
    add_column :corporations, :document_type, :string
  end
end
