class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.references :country, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
