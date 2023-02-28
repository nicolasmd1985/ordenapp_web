class AddCommentsToThings < ActiveRecord::Migration[5.2]
  def change
    add_column :things, :comments, :text
  end
end
