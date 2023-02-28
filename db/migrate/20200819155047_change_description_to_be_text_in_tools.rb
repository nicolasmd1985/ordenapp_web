class ChangeDescriptionToBeTextInTools < ActiveRecord::Migration[5.2]
  def change
    change_column :tools, :description, :text
  end
end
