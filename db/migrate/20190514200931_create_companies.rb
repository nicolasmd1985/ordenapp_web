class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.references :status, foreign_key: true
      t.string :name
      t.string :phone
      t.string :address
      t.string :email
      t.string :identification

      t.timestamps
    end
    add_reference :users, :company, foreign_key: true

  end
end
