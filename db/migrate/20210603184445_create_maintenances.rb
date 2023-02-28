class CreateMaintenances < ActiveRecord::Migration[5.2]
  def change
    create_table :maintenances do |t|
      t.datetime :maintenance_date
      t.integer :frequency
      t.references :out_thing, foreign_key: true

      t.timestamps
    end
  end
end
