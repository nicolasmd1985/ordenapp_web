class ChangeForeignKeyForThings < ActiveRecord::Migration[5.2]
  def change
    rename_column :things, :company_id, :subsidiary_id
  end
end
