class CreateOutThings < ActiveRecord::Migration[5.2]
  def change
    create_table :out_things do |t|
      t.integer :customer_id, index: true
      # t.integer :thing_id
      t.integer :stock

      t.references :thing, foreign_key: true

      t.references :user, foreign_key: true


      t.timestamps
    end
  end
end
