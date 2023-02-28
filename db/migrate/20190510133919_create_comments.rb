class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :order, foreign_key: true
      t.references :user, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
