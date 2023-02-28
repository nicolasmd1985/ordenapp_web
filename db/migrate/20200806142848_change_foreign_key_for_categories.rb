class ChangeForeignKeyForCategories < ActiveRecord::Migration[5.2]
  def change
    rename_column :categories, :company_id, :subsidiary_id
  end
end
