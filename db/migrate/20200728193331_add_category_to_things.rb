class AddCategoryToThings < ActiveRecord::Migration[5.2]
  def change
    add_reference :things, :category, foreign_key: true
  end
end
