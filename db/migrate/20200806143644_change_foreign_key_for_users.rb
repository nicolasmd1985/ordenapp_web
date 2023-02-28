class ChangeForeignKeyForUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :company_id, :subsidiary_id
  end
end
