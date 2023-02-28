class CreateCorporations < ActiveRecord::Migration[5.2]
  def change
    create_table :corporations do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :email
      t.string :identification
      t.string :corporate_initials
      t.references :status, foreign_key: true

      t.timestamps
    end
  end
end
