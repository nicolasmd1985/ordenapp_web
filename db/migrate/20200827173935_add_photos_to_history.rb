class AddPhotosToHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :photos, :text
  end
end
