class ChangeDescriptionToBeTextInThings < ActiveRecord::Migration[5.2]
  def change
    change_column :things, :description, :text
  end
end
