class AddPhotosToThings < ActiveRecord::Migration[5.2]
  def change
    add_column :things, :photos, :text
  end
end
