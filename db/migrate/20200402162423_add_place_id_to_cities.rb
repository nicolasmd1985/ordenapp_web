class AddPlaceIdToCities < ActiveRecord::Migration[5.2]
  def change
    add_column :cities, :place_id, :string
  end
end
