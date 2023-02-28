class AddPlaceIdToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :place_id, :string
  end
end
