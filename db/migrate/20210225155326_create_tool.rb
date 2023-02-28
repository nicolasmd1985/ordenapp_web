class CreateTool < ActiveRecord::Migration[5.2]
  def change
    create_table :tools do |t|
      t.string :name
      t.text :description
      t.string :code_scan
      t.boolean :daily_use
      t.string :slug
      t.integer :tecnic_id
      t.references :user, foreign_key: true
      t.references :status, foreign_key: true
      t.references :subsidiary, foreign_key: true

      t.timestamps
    end
  end
end
