class ChangeForeignKeyForOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :company_id, :subsidiary_id
  end
end
