class AddReferencesCityToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :city_id, :integer, index: true
    add_index :orders, :city_id
  end
end
