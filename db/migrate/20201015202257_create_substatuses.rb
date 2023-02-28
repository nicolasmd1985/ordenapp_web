class CreateSubstatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :substatuses do |t|
      t.string :slug
      t.boolean :visible, default: false
      t.string :substatus_type, default: "order_status"
      t.string :description
      t.references :status, foreign_key: true
      t.references :subsidiary, foreign_key: true
      t.timestamps
    end
  end
end
