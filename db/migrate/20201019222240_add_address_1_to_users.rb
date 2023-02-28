class AddAddress1ToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :phone_number_2, :string
    rename_column :users, :phone_number, :phone_number_1
  end
end
