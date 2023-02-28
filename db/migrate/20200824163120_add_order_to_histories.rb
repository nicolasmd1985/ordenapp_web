class AddOrderToHistories < ActiveRecord::Migration[5.2]
  def change
    rename_column :histories, :text, :origin
    add_reference :histories, :user, foreign_key: true
    add_reference :histories, :order, foreign_key: true
  end
end
