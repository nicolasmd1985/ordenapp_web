class CreateComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :components do |t|
      t.string :name
      t.string :description
      t.string :code_scan
      t.string :slug
      t.references :thing, foreign_key: true
      t.references :subsidiary, foreign_key: true
      
      t.timestamps
    end
  end
end
