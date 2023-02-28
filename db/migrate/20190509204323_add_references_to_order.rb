class AddReferencesToOrder < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :supervisor_id, :integer, index: true
    add_index :orders, :supervisor_id

    add_column :orders, :customer_id, :integer, index: true
    add_index :orders, :customer_id

    add_column :orders, :tecnic_id, :integer, index: true
    add_index :orders, :tecnic_id

  end
end
