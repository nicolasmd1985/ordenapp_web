class CreateThings < ActiveRecord::Migration[5.2]
  def change
    create_table :things do |t|
      t.references :status, foreign_key: true
      t.references :order, foreign_key: true
      t.string :name
      t.string :description
      t.string :code_scan
      t.string :initial_address
      t.string :final_address

      t.timestamps
    end
  end
end
