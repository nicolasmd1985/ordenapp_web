class AddColumnsToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :contact, :string
    add_column :orders, :phone_contact, :string
  end
end
