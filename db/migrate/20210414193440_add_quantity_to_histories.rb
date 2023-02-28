class AddQuantityToHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :quantity, :integer
    add_column :histories, :discount, :integer

    rename_column :histories, :user_id, :tecnic_id

    add_column :histories, :supervisor_id, :integer, index: true
    add_index :histories, :supervisor_id

    add_column :histories, :customer_id, :integer, index: true
    add_index :histories, :customer_id

    change_column :histories, :price, :decimal, :precision => 10, :scale => 2

  end

end
