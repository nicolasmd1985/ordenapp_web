class AddReferecesCategoryToOrder < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :category, foreign_key: true
  end
end
