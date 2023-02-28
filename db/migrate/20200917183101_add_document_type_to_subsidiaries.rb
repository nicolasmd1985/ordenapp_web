class AddDocumentTypeToSubsidiaries < ActiveRecord::Migration[5.2]
  def change
    add_column :subsidiaries, :document_type, :string
  end
end
