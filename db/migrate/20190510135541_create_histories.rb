class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.references :thing, foreign_key: true
      t.string :description
      t.string :text

      t.timestamps
    end
  end
end
