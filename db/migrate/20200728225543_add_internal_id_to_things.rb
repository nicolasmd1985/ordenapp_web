class AddInternalIdToThings < ActiveRecord::Migration[5.2]
  def change
    add_column :things, :internal_id, :string
  end
end
