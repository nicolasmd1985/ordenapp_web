class ChangeDescriptionToBeTextInOrders < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :description, :text
  end
end
